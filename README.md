# emanon-ossync

Personal overrides for OSSetup (`core + personal` workspace mode).

## Bootstrap

```bash
curl -fsSL https://raw.githubusercontent.com/biendo27/emanon-ossync/main/bin/raw-bootstrap.sh | bash
```

## Workspace contract

See `.ossetup-workspace.json`.

## Daily commands

```bash
../OSSetup/bin/ossetup sync --preview
../OSSetup/bin/ossetup sync --apply
../OSSetup/bin/ossetup sync-all --scope state --apply --target auto
../OSSetup/bin/ossetup verify --strict --report
```
