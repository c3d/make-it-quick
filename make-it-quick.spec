Name:           make-it-quick
Version:        0.2.4
Release:        1%{?dist}
Summary:        A make-only build system for C/C++ programs
License:        GPLv3+
URL:            https://github.com/c3d/%{name}
Source:         https://github.com/c3d/%{name}/archive/v%{version}/%{name}-%{version}.tar.gz
BuildRequires:  make >= 3.82
BuildRequires:  gcc >= 4.8
BuildRequires:  gcc-c++ >= 4.8
Requires:       sed
Requires:       make >= 3.82
BuildArch:      noarch

%description
A simple make-only build system with basic auto-configuration that
can be used to rapidly build C and C++ programs.

%package devel
Summary:        Development files for make-it-quick
%description devel
Development files for make-it-quick

%prep
%autosetup

%build
%configure
%make_build COLORIZE= TARGET=release

%check
%make_build COLORIZE= TARGET=release check

%install
%make_install COLORIZE= TARGET=release DOC_INSTALL=

%files
%doc README.md
%doc AUTHORS
%doc NEWS
%license COPYING

%dir %{_includedir}/%{name}
%{_includedir}/%{name}/*.mk

%dir %{_datadir}/%{name}
%dir %{_datadir}/%{name}/config
%{_datadir}/%{name}/config/*.c

%files devel
%{_datadir}/pkgconfig/%{name}.pc

%changelog
* Tue Mar 19 2019 Christophe de Dinechin <dinechin@redhat.com> - 0.2.4-1
- Address review comments (see comment #11 of BZ#1689277)
- Integrate fixes found while building SPICE
* Fri Mar 15 2019 Christophe de Dinechin <dinechin@redhat.com> - 0.2.3-1
- Address review comments (see comment #7 of BZ#1689277)
* Thu Mar 14 2019 Christophe de Dinechin <dinechin@redhat.com> - 0.2.2-1
- Change the way the config.system-setup.mk file is generated
- Address issues reported by rpmlint
* Tue Mar 12 2019 Christophe de Dinechin <dinechin@redhat.com> - 0.2.1-1
- Add support for man pages and improve handling of subdirectories
* Thu Mar  7 2019 Christophe de Dinechin <dinechin@redhat.com> - 0.2
- Finish packaging work
* Thu Sep 20 2018 Christophe de Dinechin <dinechin@redhat.com> - 0.1
- Initial version of the package
