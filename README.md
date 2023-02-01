Aphidius ervi EE transcriptomics
================================

# Project Setup

## setup git access

```bash
git config --global user.email "marklammers@wwu.de"
git config --global user.name "mlammer1"
git config --global credential.helper store
```

## setup git preferences

```bash
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -l HEAD'
git config --global alias.fulllog 'log --all --oneline --graph -20'
git config --global alias.ls 'ls-files'
git config --global rerere.enabled true
git config --global pull.rebase true
```

## create folders

```bash
mkdir -p /home/mlammer1/Documents/aervi-ee-transcriptomics
cd $_
mkdir {0.data,1.code,2.pipeline,3.results,4.logs}
```

## inititate git

```bash
echo "# Aphidius ervi EE transcriptomics" >> README.md
echo -e "#.gitignore\n0.data\n2.pipeline\n3.results\n4.logs" >> .gitignore
git init
git add README.md .gitignore project.setup.md
git commit -m "Add .gitignore, README.md, and project.setup.md"
git branch -M main
git remote add origin https://github.com/LammersInsects/Aervi-EE-Transcriptomics.git
git push -u origin main
```
