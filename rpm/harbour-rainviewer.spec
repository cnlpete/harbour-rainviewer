Name:       harbour-rainviewer

# >> macros
# << macros
%define _binary_payload w2.xzdio
%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}

Summary:    Rainviewer
Version:    0.1.0
Release:    1
Group:      Applications/Internet
License:    GPLv3
BuildArch:  noarch
URL:        https://github.com/cnlpete/harbour-rainviewer
Source0:    %{name}-%{version}.tar.bz2
Requires:   sailfishsilica-qt5 >= 1.1.0
Requires:   libsailfishapp-launcher

BuildRequires:  qt5-qttools-linguist
BuildRequires:  pkgconfig(sailfishapp)
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(Qt5Positioning)
BuildRequires:  pkgconfig(Qt5Location)
BuildRequires:  desktop-file-utils

%description
This app shows the current rainviewer overlay curtesy to rainviewer.com

%if "%{?vendor}" == "chum"
PackageName: Rainviewer
Type: desktop-application
Categories:
 - Science
 - Weather
 - News
DeveloperName: Hauke Schade
Custom:
 - RepoType: github
 - Repo: https://github.com/cnlpete/harbour-rainviewer
Icon: https://raw.githubusercontent.com/cnlpete/harbour-rainviewer/master/icons/172x172/harbour-rainviewer.png
Screenshots:
 - https://raw.githubusercontent.com/cnlpete/harbour-rainviewer/master/main.png
Url:
  Homepage: https://github.com/cnlpete/harbour-rainviewer
  Help: https://github.com/cnlpete/harbour-rainviewer/discussions
  Bugtracker: https://github.com/cnlpete/harbour-rainviewer/issues
  Donation: https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=WUWGSGAK8K7ZN
%endif

%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qtc_qmake5 

%qtc_make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_datadir}/%{name}
%{_datadir}/icons/hicolor/*/apps/%{name}.png
%{_datadir}/applications/%{name}.desktop
%{_datadir}/%{name}/qml
# >> files
# << files
