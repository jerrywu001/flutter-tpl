#!/bin/bash

ENV="development"

case "$1" in
  --dev|--development)
    ENV="development"
    ;;
  --prod|--production)
    ENV="production"
    ;;
  --mock)
    ENV="mock.local"
    ;;
  "")
    ENV="development"
    ;;
  *)
    echo "Usage: $0 [--dev|--prod|--mock]"
    exit 1
    ;;
esac

echo "Running with environment: $ENV"

if [ "$ENV" = "mock.local" ]; then
  echo "Starting mock server..."
  (cd mocks && npm start) &
  MOCK_PID=$!
  sleep 2
  trap "kill $MOCK_PID 2>/dev/null" EXIT
fi

flutter run --dart-define-from-file .env.$ENV
