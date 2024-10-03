#!/bin/bash

VERSION="v0.1.0"

function show_help {
  echo "Usage: sysopctl [COMMAND] [OPTIONS]"
  echo ""
  echo "Commands:"
  echo "  service list           List all running services"
  echo "  service start [name]   Start a specific service"
  echo "  service stop [name]    Stop a specific service"
  echo "  system load            Show system load averages"
  echo "  disk usage             Show disk usage statistics"
  echo "  process monitor        Monitor system processes (like top)"
  echo "  logs analyze           Analyze system logs"
  echo "  backup [path]          Backup system files"
  echo "  --help                 Show this help message"
  echo "  --version              Show version information"
}

function show_version {
  echo "sysopctl version $VERSION"
}

# Command Handlers

function list_services {
  systemctl list-units --type=service
}

function start_service {
  if [ -z "$1" ]; then
    echo "Please provide a service name."
    exit 1
  fi
  sudo systemctl start "$1"
  echo "Service $1 started."
}

function stop_service {
  if [ -z "$1" ]; then
    echo "Please provide a service name."
    exit 1
  fi
  sudo systemctl stop "$1"
  echo "Service $1 stopped."
}

function system_load {
  uptime
}

function disk_usage {
  df -h
}

function process_monitor {
  top
}

function analyze_logs {
  journalctl -p crit -n 10
}

function backup_files {
  if [ -z "$1" ]; then
    echo "Please provide a path to backup."
    exit 1
  fi
  rsync -av --progress "$1" /backup/
  echo "Backup of $1 initiated."
}

# Command Dispatcher

case "$1" in
  --help)
    show_help
    ;;
  --version)
    show_version
    ;;
  service)
    case "$2" in
      list)
        list_services
        ;;
      start)
        start_service "$3"
        ;;
      stop)
        stop_service "$3"
        ;;
      *)
        echo "Unknown service command. Use sysopctl --help for more information."
        ;;
    esac
    ;;
  system)
    if [ "$2" == "load" ]; then
      system_load
    else
      echo "Unknown system command. Use sysopctl --help for more information."
    fi
    ;;
  disk)
    if [ "$2" == "usage" ]; then
      disk_usage
    else
      echo "Unknown disk command. Use sysopctl --help for more information."
    fi
    ;;
  process)
    if [ "$2" == "monitor" ]; then
      process_monitor
    else
      echo "Unknown process command. Use sysopctl --help for more information."
    fi
    ;;
  logs)
    if [ "$2" == "analyze" ]; then
      analyze_logs
    else
      echo "Unknown logs command. Use sysopctl --help for more information."
    fi
    ;;
  backup)
    backup_files "$2"
    ;;
  *)
    echo "Unknown command. Use sysopctl --help for more information."
    ;;
esac
