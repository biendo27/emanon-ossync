# emanon-ossync

Personal runtime data repository for OSSetup (`core engine + personal data`).

## Bootstrap

```bash
curl -fsSL https://raw.githubusercontent.com/biendo27/emanon-ossync/main/bin/raw-bootstrap.sh | bash
```

## Initialize/repair personal data tree

```bash
./bin/init-personal-data.sh
```

## Daily commands

```bash
../OSSetup/bin/ossetup sync --preview
../OSSetup/bin/ossetup sync --apply
../OSSetup/bin/ossetup sync-all --scope state --apply --target auto
../OSSetup/bin/ossetup promote --target auto --scope all --from-state latest --apply
../OSSetup/bin/ossetup verify --strict --report
```
