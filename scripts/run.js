#!/usr/bin/env node

const { spawn, exec } = require('child_process');
const { join } = require('path');

/// 检查端口是否被占用
function isPortInUse(port, callback) {
  const command = process.platform === 'win32'
    ? `netstat -ano | findstr :${port}`
    : `lsof -i :${port} || lsof -iTCP -sTCP:LISTEN | grep :${port}`;

  exec(command, (error, stdout) => {
    // 如果命令执行成功且有输出，说明端口被占用
    const isUsed = !error && stdout.trim().length > 0;
    callback(isUsed);
  });
}

// 解析命令行参数
const args = process.argv.slice(2);
let env = 'development';
const skipRunFlutter = args.includes('--skip-run-flutter');

if (args.includes('--dev') || args.includes('--development')) {
  env = 'development';
} else if (args.includes('--prod') || args.includes('--production')) {
  env = 'production';
} else if (args.includes('--mock')) {
  env = 'mock.local';
} else if (args.length === 0) {
  env = 'development';
} else {
  console.error('Usage: node run.js [--dev|--prod|--mock] [--skip-run-flutter]');
  process.exit(1);
}

console.log(`Running with environment: ${env}`);

// 如果是 mock 环境，先检查 mock 服务器是否已启动
if (env === 'mock.local') {
  const mockPort = 6009; // Mock 服务器端口

  isPortInUse(mockPort, (isInUse) => {
    if (isInUse) {
      console.log(`Mock server is already running on port ${mockPort}, skipping startup...`);
      console.log('');
      if (!skipRunFlutter) {
        startFlutter(env, null);
      } else {
        console.log('Skipping Flutter startup as requested.');
        process.exit(0);
      }
    } else {
      console.log('Starting mock server...');

      // mock 服务器在后台运行，不占用标准输入
      const mockServer = spawn('npm', ['start'], {
        cwd: join(__dirname, '..', 'mocks'),
        stdio: ['ignore', 'pipe', 'pipe'], // 忽略 stdin，捕获 stdout 和 stderr
        shell: true,
      });

      // 输出 mock 服务器的日志
      mockServer.stdout.on('data', (data) => {
        console.log(`[Mock Server] ${data.toString().trim()}`);
      });

      mockServer.stderr.on('data', (data) => {
        console.error(`[Mock Server Error] ${data.toString().trim()}`);
      });

      // 处理 mock 服务器错误
      mockServer.on('error', (err) => {
        console.error('Mock server error:', err);
        process.exit(1);
      });

      if (!skipRunFlutter) {
        // 等待 2 秒让 mock 服务器启动
        setTimeout(() => {
          startFlutter(env, mockServer);
        }, 2000);
      } else {
        console.log('Skipping Flutter startup as requested.');
        console.log('Mock server is running.');
        console.log('Press Ctrl+C to stop the mock server.');

        // 处理 Ctrl+C
        process.on('SIGINT', () => {
          console.log('\nStopping mock server...');
          mockServer.kill();
          process.exit(0);
        });

        // 处理 mock 服务器退出
        mockServer.on('close', (code) => {
          console.log(`Mock server exited with code ${code}`);
          process.exit(code);
        });
      }
    }
  });
} else {
  startFlutter(env, null);
}

function startFlutter(env, mockServer) {
  console.log(`\nStarting Flutter with .env.${env}...\n`);

  const flutter = spawn(
    'flutter',
    ['run', '--dart-define-from-file', `.env.${env}`],
    {
      cwd: join(__dirname, '..'),
      stdio: 'inherit',
      shell: true,
    }
  );

  // 处理 Flutter 进程退出
  flutter.on('close', (code) => {
    if (mockServer) {
      console.log('\nStopping mock server...');
      mockServer.kill();
    }
    process.exit(code);
  });

  // 处理 Ctrl+C
  process.on('SIGINT', () => {
    console.log('\nReceived SIGINT, cleaning up...');
    flutter.kill();
    if (mockServer) {
      mockServer.kill();
    }
    process.exit(0);
  });

  // 处理 Flutter 错误
  flutter.on('error', (err) => {
    console.error('Flutter error:', err);
    if (mockServer) {
      mockServer.kill();
    }
    process.exit(1);
  });
}
