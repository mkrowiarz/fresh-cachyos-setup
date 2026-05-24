# Btrfs snapshot helpers (CachyOS default: btrfs + snapper).
# Take a baseline before running ./run_me.sh, restore if it goes sideways.

SNAPPER_CONFIG ?= root
DESC ?= fresh-cachyos-setup baseline

.DEFAULT_GOAL := help
.PHONY: help snapshot list reset restore

help:            ## Show this help
	@grep -E '^[a-z-]+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##/\t/'

snapshot:        ## Create the baseline snapshot (run once on a clean install)
	sudo snapper -c $(SNAPPER_CONFIG) create -d "$(DESC)"
	@sudo snapper -c $(SNAPPER_CONFIG) list | tail -n 5

list:            ## List snapshots
	@sudo snapper -c $(SNAPPER_CONFIG) list

reset:           ## Roll back to the labeled baseline, then reboot
	@n=$$(sudo snapper -c $(SNAPPER_CONFIG) list | grep -F "$(DESC)" | head -1 | awk '{print $$1}'); \
	test -n "$$n" || { echo "No snapshot labeled '$(DESC)'. Run: make snapshot"; exit 1; }; \
	echo "Rolling back to snapshot $$n ($(DESC))"; \
	sudo snapper -c $(SNAPPER_CONFIG) rollback $$n; \
	echo "Done. Reboot to boot the clean baseline."

restore:         ## Roll back to a specific snapshot: make restore N=<number>
	@test -n "$(N)" || { echo "Usage: make restore N=<snapshot-number>  (see: make list)"; exit 1; }
	sudo snapper -c $(SNAPPER_CONFIG) rollback $(N)
	@echo "Rollback staged. Reboot to apply."
