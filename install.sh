#!/usr/bin/env bash

# Vars
prg='spm'
DESTDIR=''

# Verification
[[ "$UID" -ne "0" ]] && { echo "Only root."; exit 1 ;}

# Header
echo "###################################################"
echo "   SPM Install, bugs? contato.wxkz@gmail.com        "
echo -e "###################################################\n"

# Code
# Analising Parameters
for param in "$@"; do
    shift
    # Ex: DESTDIR=/caminho/para/dir ou DESTDIR /caminho/para/dir
    if [[ "$param" = 'DESTDIR'* ]]; then
        [[ "$param" = *'='* ]] && DESTDIR="${param#*=}" || DESTDIR="$1"
        # remove ultima barra
        DESTDIR="${DESTDIR%*/}"
    fi
done

# Dando permissões e copiando arquivos para seus lugares.
echo -e "\nPermission and Copy archives\n"
install -vDm755 -t "${DESTDIR}/sbin/" "$prg" || exit 1
install -vDm644 -t "${DESTDIR}/usr/share/man/pt_BR/man8/" 'spm.8' || exit 1
install -vDm644 -t "${DESTDIR}/usr/libexec/spm/" {core,help}'.sh' || exit 1
# Verifica se arquivo de configuração existe para cria-lo ou .new
if [[ -e "${DESTDIR}/etc/spm/${prg}.conf" ]]; then
    cmp -s "${prg}.conf" "${DESTDIR}/etc/spm/${prg}.conf" ||
        install -vDm644 "${prg}.conf" "${DESTDIR}/etc/spm/${prg}.conf.new" || exit 1
else
    install -vDm644 -t "${DESTDIR}/etc/spm/" "${prg}.conf" || exit 1
fi

# Creating paths if does not exist
mkdir -vp "${DESTDIR}/var/lib/spm/"{list,desc,remove}

echo -e "\nFINNALY! WORK NOW, call spm"
