#!/usr/bin/env node

const { networkInterfaces } = require('os');
const { writeFileSync, existsSync } = require('fs');
const { execSync } = require('child_process');
const { join } = require('path');

// 检查并安装依赖
const rootDir = join(__dirname, '..');
const nodeModulesPath = join(rootDir, 'node_modules');

if (!existsSync(nodeModulesPath)) {
  console.log('node_modules 不存在，正在安装依赖...\n');
  execSync('pnpm i', { stdio: 'inherit', cwd: rootDir });
  console.log('\n✓ 依赖安装完成\n');
}

function getLocalIP() {
  const nets = networkInterfaces();
  for (const name of Object.keys(nets)) {
    for (const net of nets[name]) {
      if (net.family === 'IPv4' && !net.internal) {
        return net.address;
      }
    }
  }
  throw new Error('无法检测到本机IP地址');
}

const localIP = getLocalIP();
const envContent = `# ====== mock，填写你本机的ip 地址 + 6009 ====
API_HOST = http://${localIP}:6009
ENV_NAME = mock
`;

const envPath = join(__dirname, '..', '.env.mock.local');
writeFileSync(envPath, envContent, 'utf8');
console.log(`✓ 已创建 .env.mock.local，API_HOST = http://${localIP}:6009`);

const envOnly = process.argv.includes('--env-only');
if (!envOnly) {
  console.log('\n运行 Flutter with mock environment...\n');
  execSync('node scripts/run.js --mock', { stdio: 'inherit', cwd: join(__dirname, '..') });
}
