#!/usr/bin/env node

const { networkInterfaces } = require('os');
const { writeFileSync } = require('fs');
const { execSync } = require('child_process');
const { join } = require('path');

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
  console.log('\n运行 ./run.sh --mock...\n');
  execSync('./scripts/run.sh --mock', { stdio: 'inherit', cwd: join(__dirname, '..') });
}
