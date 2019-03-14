Name:           make-it-quick
Version:        0.2.1
Release:        1%{?dist}
Summary:        A make-only build system for C/C++ programs
License:        GPLv3+
URL:            https://gitlab.com/c3d/%{name}
Source:         https://github.com/c3d/%{name}/archive/v%{version}/%{name}-%{version}.tar.gz
BuildRequires:  make >= 3.82
BuildRequires:  gcc >= 4.8
BuildRequires:  gcc-c++ >= 4.8
Requires:       sed
BuildArch:      noarch

%description
A simple make-only build system with basic auto-configuration that
can be used to rapidly build C and C++ programs.

%prep
%autosetup

%build
%configure
%make_build COLORIZE= TARGET=release
%make_build COLORIZE= AUTHORS NEWS

%check
%make_build COLORIZE= TARGET=release check

%install
%make_install COLORIZE= TARGET=release

%files
%{_libdir}/%{name}/config/*.c
%{_includedir}/%{name}/*.mk
%{_datarootdir}/pkgconfig/%{name}.pc
%license LICENSE
%doc README.md
%doc AUTHORS
%doc NEWS

%changelog
* Thu Mar 12 2019 Christophe de Dinechin <dinechin@redhat.com> - 0.2.1-1
- Add support for man pages and improve handling of subdirectories
* Thu Mar  7 2019 Christophe de Dinechin <dinechin@redhat.com> - 0.2
- Finish packaging work
* Thu Sep 20 2018 Christophe de Dinechin <dinechin@redhat.com> - 0.1
- Initial version of the package
