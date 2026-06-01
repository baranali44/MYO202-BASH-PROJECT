#!/bin/bash

# İsim SOYİSİM: Ali Baran BERKTAŞ
# Öğrenci Numarası: 2420191033
# Sertifika Bağlantıları (3 Adet bağlantı):
# 1. Docker Temelleri: https://github.com/baranali44/MYO202-BASH-PROJECT/blob/main/sertifikalar/docker.pdf
#    BTK Akademi Doğrulama Bağlantısı: https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=qKrhe9aVzz
# 2. Siber Güvenlikte Linux İşletim Sistemleri: https://github.com/baranali44/MYO202-BASH-PROJECT/blob/main/sertifikalar/linux.pdf
#    BTK Akademi Doğrulama Bağlantısı: https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=OKMhw1PKVa
# 3. Linux Bash Script Eğitimi: https://github.com/baranali44/MYO202-BASH-PROJECT/blob/main/sertifikalar/bash.pdf
#    TechCareer Doğrulama Bağlantısı: https://credsverse.com/credentials/86a1173c-02a5-4bbd-b2af-2e337535678f


# --- 1. Log Dosyası Oluşturma ve Tarih Yazdırma ---
# report.log dosyasını oluşturur ve ilk satıra ISO 8601 formatında zaman damgası ekler.
date --iso-8601=seconds > report.log

# --- 2. Donanım Bilgilerinin Çekilmesi (Windows İçin) ---
echo -e "\n=== İŞLEMCİ BİLGİSİ (Marka, Model) ===" >> report.log
wmic cpu get manufacturer, name >> report.log

echo -e "\n=== RAM BİLGİSİ (Üretici, Parça Numarası/Model, Seri No, Kapasite) ===" >> report.log
wmic memorychip get manufacturer, partnumber, serialnumber, capacity >> report.log

echo -e "\n=== ANAKART BİLGİSİ (Üretici, Model, Seri No) ===" >> report.log
wmic baseboard get manufacturer, product, serialnumber >> report.log

echo -e "\n=== UUID BİLGİSİ ===" >> report.log
wmic csproduct get uuid >> report.log

echo -e "\n=== DİSK BİLGİSİ (Marka/Model, Seri No, Kapasite) ===" >> report.log
wmic diskdrive get model, serialnumber, size >> report.log

echo -e "\n=== MAC ADRESİ BİLGİSİ ===" >> report.log
getmac >> report.log

# --- 3. Kullanıcıdan Parola Alınması ---
# Girilecek parolanın "MYO+202" olması beklenmektedir.
echo "Lütfen parolayı giriniz:"
read -s PAROLA

# Windows (Git Bash) ortamında 'Enter' basıldığında sona eklenen gizli \r (Carriage Return) karakterini temizleyelim:
PAROLA=$(echo -n "$PAROLA" | tr -d '\r\n')

echo "" # Yeni satıra geçmek için

# Şifrenin doğru girilip girilmediğini kontrol edelim (Hata payını sıfıra indirmek için):
if [ "$PAROLA" != "MYO+202" ]; then
    echo "HATA: Parolayı yanlış girdiniz! (Sizin girdiğiniz: '$PAROLA', Olması gereken: 'MYO+202')"
    echo "Lütfen scripti tekrar çalıştırın ve parolayı doğru yazın."
    rm report.log
    exit 1
fi

# --- 4. GPG ile Şifreleme (Batch Modda AES256) ---
# Girilen parola kullanılarak dosya simetrik olarak şifrelenir.
gpg --batch --yes --passphrase "$PAROLA" --pinentry-mode loopback -c --cipher-algo AES256 report.log

# --- 5. Orijinal Dosyanın Silinmesi ---
rm report.log

echo "İşlem başarıyla tamamlandı! report.log.gpg oluşturuldu ve orijinal dosya silindi."
