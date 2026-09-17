# ABAP-OOP---Car-Rental-Management-System
Bu proje, ABAP Object-Oriented Programming (OOP) prensiplerini göstermek amacıyla geliştirilmiştir.

Encapsulation (Kapsülleme): Değişkenler READ-ONLY veya PRIVATE yapılarak dış müdahalelere kapatılmıştır.

Abstraction (Soyutlama): lcl_car soyut (Abstract) bir üst sınıf olarak tasarlanmış, fatura metodu alt sınıflara şablon olarak zorunlu tutulmuştur.

Inheritance (Kalıtım): lcl_suv ve lcl_sedan alt sınıfları ana class'dan miras alarak kendi iş kurallarını (REDEFINITION) işletmektedir.

Polymorphism (Çok Biçimlilik): Sistemdeki tüm araçlar tek bir jenerik referans (TYPE REF TO lcl_car) üzerinden dinamik olarak üretilip yönetilmektedir.

Clean Code
