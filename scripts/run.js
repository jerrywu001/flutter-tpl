#!/usr/bin/env node

const { spawn } = require('child_process');
const { join } = require('path');

// 解析命令行参数
const args = process.argv.slice(2);
let env = 'development';

if (args.includes('--dev') || args.includes('--development')) {
  env = 'development';
} else if (args.includes('--prod') || args.includes('--production')) {
  env = 'production';
} else if (args.includes('--mock')) {
  env = 'mock.local';
} else if (args.length === 0) {
  env = 'development';
} else {
  console.error('Usage: node run.js [--dev|--prod|--mock]');
  process.exit(1);
}

console.log(`Running with environment: ${env}`);

// 如果是 mock 环境，先启动 mock 服务器
if (env === 'mock.local') {
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

  // 等待 2 秒让 mock 服务器启动
  setTimeout(() => {
    startFlutter(env, mockServer);
  }, 2000);

  // 处理 mock 服务器错误
  mockServer.on('error', (err) => {
    console.error('Mock server error:', err);
    process.exit(1);
  });
} else {
  startFlutter(env);
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
