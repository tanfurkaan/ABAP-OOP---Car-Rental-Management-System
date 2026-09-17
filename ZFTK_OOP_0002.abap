REPORT ZFTK_OOP_0002.

CLASS lcl_suv DEFINITION DEFERRED.
CLASS lcl_sedan DEFINITION DEFERRED.
CLASS lcl_car DEFINITION DEFERRED.

DATA: go_arac TYPE REF TO lcl_car.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS: p_plaka  TYPE char10,
            p_marka  TYPE string,
            p_model  TYPE string,
            p_gnkrfy TYPE int4,
            p_km     TYPE int4,
            p_gun    TYPE int4.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
PARAMETERS: p_sedan RADIOBUTTON GROUP gr1,
            p_suv   RADIOBUTTON GROUP gr1.
SELECTION-SCREEN END OF BLOCK b2.


CLASS lcl_car DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING iv_plaka       TYPE char10
                            iv_marka       TYPE string
                            iv_model       TYPE string
                            iv_gnkirafiyat TYPE int4
                            iv_km          TYPE int4,
      teslim_al IMPORTING iv_kullanilan_km TYPE int4,
      fatura ABSTRACT IMPORTING iv_gun           TYPE int4
                      RETURNING VALUE(rv_toplam) TYPE int4,
      ozet_yazdir.

    DATA: mv_plaka       TYPE char10  READ-ONLY,
          mv_marka       TYPE string READ-ONLY,
          mv_model       TYPE string READ-ONLY,
          mv_gnkirafiyat TYPE int4   READ-ONLY,
          mv_km          TYPE int4   READ-ONLY.

ENDCLASS.

CLASS lcl_car IMPLEMENTATION.

  METHOD constructor.
    mv_plaka       = iv_plaka.
    mv_marka       = iv_marka.
    mv_model       = iv_model.
    mv_gnkirafiyat = iv_gnkirafiyat.
    mv_km          = iv_km.

  ENDMETHOD.

  METHOD teslim_al.
    mv_km = mv_km + iv_kullanilan_km.
  ENDMETHOD.

  METHOD ozet_yazdir.
    WRITE: / '------------------------------------',
           / 'Plakası:', mv_plaka,
           / 'Model:', mv_model,
           / 'Marka:', mv_marka,
           / 'Guncel Km:', mv_km.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_suv DEFINITION INHERITING FROM lcl_car.
  PUBLIC SECTION.
    CONSTANTS: c_vip_ucret TYPE int4 VALUE 2500.
    METHODS:
      constructor IMPORTING iv_plaka       TYPE char10
                            iv_marka       TYPE string
                            iv_model       TYPE string
                            iv_gnkirafiyat TYPE int4
                            iv_km          TYPE int4,
      fatura REDEFINITION.

  PRIVATE SECTION.
    DATA mv_vip_fiyat TYPE int4.

ENDCLASS.

CLASS lcl_suv IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
      EXPORTING
        iv_plaka       = iv_plaka
        iv_marka       = iv_marka
        iv_model       = iv_model
        iv_gnkirafiyat = iv_gnkirafiyat
        iv_km          = iv_km
    ).
    mv_vip_fiyat = c_vip_ucret.
  ENDMETHOD.

  METHOD fatura.
    rv_toplam = iv_gun * mv_gnkirafiyat + mv_vip_fiyat.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_sedan DEFINITION INHERITING FROM lcl_car.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING iv_plaka       TYPE char10
                            iv_marka       TYPE string
                            iv_model       TYPE string
                            iv_gnkirafiyat TYPE int4
                            iv_km          TYPE int4,
      fatura REDEFINITION.

ENDCLASS.

CLASS lcl_sedan IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
      EXPORTING
        iv_plaka       = iv_plaka
        iv_marka       = iv_marka
        iv_model       = iv_model
        iv_gnkirafiyat = iv_gnkirafiyat
        iv_km          = iv_km
    ).
  ENDMETHOD.

  METHOD fatura.
    rv_toplam = iv_gun * mv_gnkirafiyat.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  IF p_suv = abap_true.
    CREATE OBJECT go_arac TYPE lcl_suv
      EXPORTING
        iv_plaka       = p_plaka
        iv_marka       = p_marka
        iv_model       = p_model
        iv_gnkirafiyat = p_gnkrfy
        iv_km          = p_km.

  ELSEIF p_sedan = abap_true.
    CREATE OBJECT go_arac TYPE lcl_sedan
      EXPORTING
        iv_plaka       = p_plaka
        iv_marka       = p_marka
        iv_model       = p_model
        iv_gnkirafiyat = p_gnkrfy
        iv_km          = p_km.
  ENDIF.

  go_arac->teslim_al( iv_kullanilan_km = 2000 ).
  go_arac->ozet_yazdir( ).
  WRITE: / 'Toplam Fatura Tutarı: ', go_arac->fatura( iv_gun = p_gun ),'TL'.
