#!/bin/bash
# cryptcheck-rails Entrypoint

# debug
#set -x

case $1 in
    front|puma|rails)
        echo "Starting puma webserver ..."
        puma -e production
        ;;
    back|sidekiq|sidekik)
        echo "Starting sidekiq ..."
        LD_LIBRARY_PATH=/opt/cryptcheck/lib bin/sidekiq -e production
        ;;
    bash)
        echo "Starting bash debug"
        bash
        ;;
    *)
        echo "Wrong startup command"
        echo "Usage:"
        echo ""
        echo -e "puma\t\t launch a puma webserver"
        echo -e "sidekiq\t\t launch sidekiq"
        echo -e "bash\t\t stat a bash to debug"
        exit 1
        ;;
esac
