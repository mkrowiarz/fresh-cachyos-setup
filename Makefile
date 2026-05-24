# Btrfs snapshot helpers (CachyOS default: btrfs + snapper).
# Take a baseline before running ./run_me.sh, restore if it goes sideways.

SNAPPER_CONFIG ?= root
DESC ?= fresh-cachyos-setup baseline

.DEFAULT_GOAL := help
.PHONY: help snapshot list restore

help:            ## Show this help
	@grep -E '^[a-z-]+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##/\t/'

snapshot:        ## Create a pre-setup snapshot
	sudo snapper -c $(SNAPPER_CONFIG) create -d "$(DESC)"
	@sudo snapper -c $(SNAPPER_CONFIG) list | tail -n 5

list:            ## List snapshots
	@sudo snapper -c $(SNAPPER_CONFIG) list

restore:         ## Roll back to a snapshot: make restore N=<number>
	@test -n "$(N)" || { echo "Usage: make restore N=<snapshot-number>  (see: make list)"; exit 1; }
	sudo snapper -c $(SNAPPER_CONFIG) rollback $(N)
	@echo "Rollback staged. Reboot to apply."
