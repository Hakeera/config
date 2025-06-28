# 🐧 Instalação do Arch Linux em Dual Boot com Windows (UEFI)

## 🧾 Pré-requisitos

- Backup feito
- Pendrive bootável com Arch Linux
- Internet por cabo (ou pronto para configurar Wi-Fi via `iwctl`)
- UEFI confirmado: `ls /sys/firmware/efi` retorna algo

---

## 🚀 Passo 1 – Boot pelo Pendrive

1. Insira o pendrive
2. Reinicie o computador
3. Acesse o menu de boot (geralmente `F12`, `F10` ou `Esc`)
4. Selecione o pendrive **modo UEFI**
5. Na tela do Arch, selecione:  
   `Arch Linux install medium (x86_64, UEFI)`

---

## 🌐 Passo 2 – Conecte-se à Internet

### Com fio: já funciona
### Com Wi-Fi:
```bash
iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect NOMEDAREDE
```

Verifique com:
```bash
ping archlinux.org
```

---

## 💽 Passo 3 – Formatar a partição do Ubuntu

### ⚠️ Você irá usar: `/dev/nvme0n1p6`
```bash
mkfs.ext4 /dev/nvme0n1p6
```

---

## 📂 Passo 4 – Montar as partições

```bash
mount /dev/nvme0n1p6 /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

---

## 📦 Passo 5 – Instalar o sistema base

```bash
pacstrap /mnt base linux linux-firmware vim nano networkmanager grub efibootmgr
```

---

## 🧠 Passo 6 – Configurar sistema

```bash
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

### Timezone:
```bash
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
```

### Locale:
```bash
echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=pt_BR.UTF-8" > /etc/locale.conf
```

### Hostname:
```bash
echo arch > /etc/hostname
```

### Hosts:
```bash
cat <<EOF > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   arch.localdomain arch
EOF
```

---

## 🔑 Passo 7 – Senha de root

```bash
passwd
```

---

## 🧰 Passo 8 – Instalar o GRUB (UEFI)

```bash
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

> O GRUB detectará o Windows automaticamente

---

## 🌐 Passo 9 – Ativar rede

```bash
systemctl enable NetworkManager
```

---

## 🏁 Passo 10 – Finalizar

```bash
exit
umount -R /mnt
reboot
```

Remova o pendrive. O GRUB deve exibir opções para Arch Linux e Windows.

---

## 🎯 Pós-instalação (recomendado)

### Criar usuário:
```bash
useradd -m -G wheel -s /bin/bash leonardo
passwd leonardo
```

### Dar permissão sudo:
```bash
EDITOR=nano visudo
```
Descomente:
```
%wheel ALL=(ALL:ALL) ALL
```

---

### Instalar ambiente gráfico (exemplo: i3)
```bash
pacman -S xorg xterm i3 lightdm lightdm-gtk-greeter
systemctl enable lightdm
```

---

✅ Pronto! Seu Arch Linux está funcional e em dual boot com o Windows.
