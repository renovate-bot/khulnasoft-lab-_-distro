%global debug_package %{nil}
%global _missing_build_ids_terminate_build 0
%global _dwz_low_mem_die_limit 0

Name:           distro
Version:        2.8.90
Release:        1%{?dist}
Summary:        Ansible Distro is a modern UI for Ansible. It lets you easily run Ansible playbooks, get notifications about fails, control access to deployment system.

License:        MIT
URL:            https://github.com/khulnasoft-lab/distro
Source:         https://github.com/khulnasoft-lab/distro/archive/refs/tags/v2.8.90.zip

BuildRequires:  golang
BuildRequires:  nodejs
BuildRequires:  nodejs-npm
BuildRequires:  go-task
BuildRequires:  git
BuildRequires:  systemd-rpm-macros

Requires:       ansible

%description
Ansible Distro is a modern UI for Ansible. It lets you easily run Ansible playbooks, get notifications about fails, control access to deployment system.

%prep
%setup -q

%build
export DISTRO_VERSION="development"
export DISTRO_ARCH="linux_amd64"
export DISTRO_CONFIG_PATH="./etc/distro"
export APP_ROOT="./ansible-distro/"

if ! [[ "$PATH" =~ "$HOME/go/bin:" ]]
then
    PATH="$HOME/go/bin:$PATH"
fi
export PATH
##go install github.com/gobuffalo/packr/v2@latest
go-task all

cat > ansible-distro.service <<EOF
[Unit]
Description=Distro Ansible
Documentation=https://github.com/khulnasoft-lab/distro
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=%{_bindir}/distro service --config=/etc/distro/config.json
SyslogIdentifier=distro
Restart=always

[Install]
WantedBy=multi-user.target

EOF

cat > distro-setup <<EOF
distro setup --config=/etc/distro/config.json
EOF

%install
mkdir -p %{buildroot}%{_sysconfdir}/distro/
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_unitdir}

install -m 755 bin/distro %{buildroot}%{_bindir}/distro
install -m 755 distro-setup %{buildroot}%{_bindir}/distro-setup
install -m 755 ansible-distro.service %{buildroot}%{_unitdir}/ansible-distro.service

%files
%license LICENSE
%doc README.md CONTRIBUTING.md
%attr(755, root, root) %{_bindir}/distro
%attr(755, root, root) %{_bindir}/distro-setup
%attr(644, root,root) %{_sysconfdir}/distro/
%{_unitdir}/ansible-distro.service

%changelog
* Wed Jun 28 2023 Neftali Yagua
-
