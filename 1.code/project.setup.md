# Project Setup

## Git

```bash
git --version
```

### Setup git access

```bash
git config --global user.email "marklammers@wwu.de"
git config --global user.name "mlammer1"
git config --global credential.helper store
```

### Setup git preferences

```bash
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -l HEAD'
git config --global alias.fulllog 'log --all --oneline --graph -20'
git config --global alias.ls 'ls-files'
git config --global rerere.enabled true
git config --global pull.rebase true
```

### Create folders

```bash
mkdir -p /home/mlammer1/Documents/aervi-ee-transcriptomics
cd $_
mkdir {0.data,1.code,2.pipeline,3.results,4.logs}
```

### Initiate git

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

## Bioinformatics software

### Enable R on jgant3

```bash
source /usr/share/modules/init/bash  # enables the module
module use /global/projects/programs/modules/
module load dev/R
```

### Install HISAT2 on jgant3

```bash
#download the installer for linux into software folder:
cd ~/software
curl -s https://cloud.biohpc.swmed.edu/index.php/s/oTtGWbWjaxsQ2Ho/download > hisat2-2.2.1-Linux_x86_64.zip
#then unzip it
unzip hisat2-2.2.1-Linux_x86_64.zip
#add the folder to PATH:
echo 'export PATH="$HOME/software/hisat2-2.2.1:$PATH"' >>~/.bashrc
source ~/.bashrc
```

- By default, `HISAT2` uses `#!/usr/bin/env python` as shebang. It may be necessary to change the shebang to the output `which python3`.
  - This is the case for `hisat2-huild` on `jgant3`.
