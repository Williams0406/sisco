"""
models.py — App movimientos
Contiene: DET_TARIFARIO, MOV_TICKET, CAB_DOCUMENTO_VENTA,
          CAB_COBRANZA_CREDITO, DET_COBRANZA_CREDITO,
          CAB_CIERRE_TURNO, CAB_RECIBO_EGRESO, CAB_RECIBO_INGRESO
"""
from django.db import models
from maestros.models import (
    MaeCliente, MaeChofer, MaeTipoVehiculo, MaeVehiculo,
    MaeTipoIncidente, MaeTipoEgreso, MaeTipoIngreso, MaeGarita,
)


# ---------------------------------------------------------------------------
# TARIFARIO
# ---------------------------------------------------------------------------

class DetTarifario(models.Model):
    """
    Tarifas por tipo de vehículo.
    Opcionalmente asignadas a un cliente VIP específico.
    """
    nu_codi_tarifario = models.AutoField(primary_key=True)
    ch_tipo_vehiculo = models.ForeignKey(
        MaeTipoVehiculo,
        on_delete=models.PROTECT,
        db_column='CH_TIPO_VEHICULO',
        to_field='ch_tipo_vehiculo',
        null=True, blank=True,
        related_name='tarifas',
    )
    ch_codi_cliente = models.ForeignKey(
        MaeCliente,
        on_delete=models.PROTECT,
        db_column='CH_CODI_CLIENTE',
        to_field='ch_codi_cliente',
        null=True, blank=True,
        related_name='tarifas',
    )
    nu_impo_tarifa = models.DecimalField(
        max_digits=12, decimal_places=3, null=True, blank=True)
    nu_minu_tolerancia = models.IntegerField(null=True, blank=True)
    ch_esta_activo = models.CharField(max_length=1, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'DET_TARIFARIO'
        verbose_name = 'Tarifario'

    def __str__(self):
        return f'Tarifa #{self.nu_codi_tarifario}'


# ---------------------------------------------------------------------------
# TICKET (ALQUILER DE COCHERA)
# ---------------------------------------------------------------------------

class MovTicket(models.Model):
    """
    Ticket de ingreso/salida de vehículo.
    Tabla central del sistema operativo.
    """
    nu_codi_ticket = models.AutoField(primary_key=True)
    dt_fech_ingre = models.DateTimeField(null=True, blank=True)
    dt_fech_salid = models.DateTimeField(null=True, blank=True)
    ch_codi_garita = models.ForeignKey(
        MaeGarita,
        on_delete=models.PROTECT,
        db_column='CH_CODI_GARITA',
        to_field='ch_codi_garita',
        null=True, blank=True,
        related_name='tickets',
    )
    ch_codi_vehiculo = models.ForeignKey(
        MaeVehiculo,
        on_delete=models.PROTECT,
        db_column='CH_CODI_VEHICULO',
        to_field='ch_codi_vehiculo',
        null=True, blank=True,
        related_name='tickets',
    )
    ch_codi_cliente = models.ForeignKey(
        MaeCliente,
        on_delete=models.PROTECT,
        db_column='CH_CODI_CLIENTE',
        to_field='ch_codi_cliente',
        null=True, blank=True,
        related_name='tickets',
    )
    ch_codi_chofer = models.ForeignKey(
        MaeChofer,
        on_delete=models.PROTECT,
        db_column='CH_CODI_CHOFER',
        to_field='ch_codi_chofer',
        null=True, blank=True,
        related_name='tickets',
    )
    nu_codi_tarifario = models.ForeignKey(
        DetTarifario,
        on_delete=models.PROTECT,
        db_column='NU_CODI_TARIFARIO',
        to_field='nu_codi_tarifario',
        null=True, blank=True,
        related_name='tickets',
    )
    ch_codi_tipo_incidente = models.ForeignKey(
        MaeTipoIncidente,
        on_delete=models.PROTECT,
        db_column='CH_CODI_TIPO_INCIDENTE',
        to_field='ch_codi_tipo_incidente',
        null=True, blank=True,
        related_name='tickets',
    )
    nu_impo_cobro = models.DecimalField(
        max_digits=12, decimal_places=3, null=True, blank=True)
    nu_minu_estancia = models.IntegerField(null=True, blank=True)
    ch_esta_ticket = models.CharField(max_length=2, null=True, blank=True)
    ch_esta_activo = models.CharField(max_length=1, null=True, blank=True)
    ch_tipo_pago = models.CharField(max_length=1, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    ch_plac_vehiculo = models.CharField(max_length=20, null=True, blank=True)
    ch_codi_turno_caja = models.CharField(max_length=2, null=True, blank=True)
    dt_fech_turno = models.DateTimeField(null=True, blank=True)
    vc_obse_ticket = models.CharField(max_length=100, null=True, blank=True)
    nu_impo_cobro_cred = models.DecimalField(
        max_digits=12, decimal_places=3, null=True, blank=True)

    class Meta:
        db_table = 'MOV_TICKET'
        verbose_name = 'Ticket'

    def __str__(self):
        return f'Ticket #{self.nu_codi_ticket} – {self.ch_plac_vehiculo}'


# ---------------------------------------------------------------------------
# COBRANZA A CRÉDITO
# ---------------------------------------------------------------------------

class CabCobranzaCredito(models.Model):
    """Cabecera de cobranza a crédito."""
    nu_codi_cobr_cred = models.AutoField(primary_key=True)
    dt_fech_cobr_cred = models.DateTimeField(null=True, blank=True)
    ch_codi_cliente = models.ForeignKey(
        MaeCliente,
        on_delete=models.PROTECT,
        db_column='CH_CODI_CLIENTE',
        to_field='ch_codi_cliente',
        null=True, blank=True,
        related_name='cobranzas_credito',
    )
    nu_impo_total = models.DecimalField(
        max_digits=12, decimal_places=3, null=True, blank=True)
    ch_esta_activo = models.CharField(max_length=1, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    ch_seri_cobr_cred = models.CharField(max_length=4, null=True, blank=True)
    ch_nume_cobr_cred = models.CharField(max_length=10, null=True, blank=True)
    ch_codi_cajero = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_garita = models.CharField(max_length=3, null=True, blank=True)
    ch_codi_turno_caja = models.CharField(max_length=2, null=True, blank=True)
    dt_fech_turno = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'CAB_COBRANZA_CREDITO'
        verbose_name = 'Cobranza a Crédito'

    def __str__(self):
        return f'Cobranza #{self.nu_codi_cobr_cred}'


class DetCobranzaCredito(models.Model):
    """Detalle (líneas de ticket) de una cobranza a crédito."""
    nu_codi_det_cobr = models.AutoField(primary_key=True)
    nu_codi_cobr_cred = models.ForeignKey(
        CabCobranzaCredito,
        on_delete=models.PROTECT,
        db_column='NU_CODI_COBR_CRED',
        to_field='nu_codi_cobr_cred',
        null=True, blank=True,
        related_name='detalles',
    )
    nu_codi_ticket = models.ForeignKey(
        MovTicket,
        on_delete=models.PROTECT,
        db_column='NU_CODI_TICKET',
        to_field='nu_codi_ticket',
        null=True, blank=True,
        related_name='detalles_cobranza',
    )
    nu_impo_cobro = models.DecimalField(
        max_digits=12, decimal_places=3, null=True, blank=True)
    ch_esta_activo = models.CharField(max_length=1, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'DET_COBRANZA_CREDITO'
        verbose_name = 'Detalle Cobranza Crédito'

    def __str__(self):
        return f'Det.Cobranza #{self.nu_codi_det_cobr}'


# ---------------------------------------------------------------------------
# DOCUMENTO DE VENTA
# ---------------------------------------------------------------------------

class CabDocumentoVenta(models.Model):
    """Comprobante de venta generado a partir de un ticket."""
    nu_codi_docu_vent = models.AutoField(primary_key=True)
    dt_fech_docu_vent = models.DateTimeField(null=True, blank=True)
    nu_codi_ticket = models.ForeignKey(
        MovTicket,
        on_delete=models.PROTECT,
        db_column='NU_CODI_TICKET',
        to_field='nu_codi_ticket',
        null=True, blank=True,
        related_name='documentos_venta',
    )
    ch_codi_cliente = models.ForeignKey(
        MaeCliente,
        on_delete=models.PROTECT,
        db_column='CH_CODI_CLIENTE',
        to_field='ch_codi_cliente',
        null=True, blank=True,
        related_name='documentos_venta',
    )
    nu_codi_cobr_cred = models.ForeignKey(
        CabCobranzaCredito,
        on_delete=models.SET_NULL,
        db_column='NU_CODI_COBR_CRED',
        to_field='nu_codi_cobr_cred',
        null=True, blank=True,
        related_name='documentos_venta',
    )
    ch_seri_cmprbt = models.CharField(max_length=4, null=True, blank=True)
    ch_nume_cmprbt = models.CharField(max_length=10, null=True, blank=True)
    vc_desc_cliente = models.CharField(max_length=100, null=True, blank=True)
    vc_dire_cliente = models.CharField(max_length=100, null=True, blank=True)
    vc_obse_cmprbt = models.CharField(max_length=100, null=True, blank=True)
    ch_tipo_cmprbnt = models.CharField(max_length=2, null=True, blank=True)
    nu_impo_total = models.DecimalField(
        max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_igv = models.DecimalField(
        max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_afecto = models.DecimalField(
        max_digits=12, decimal_places=3, null=True, blank=True)
    ch_ruc_cliente = models.CharField(max_length=11, null=True, blank=True)
    ch_esta_activo = models.CharField(max_length=1, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'CAB_DOCUMENTO_VENTA'
        verbose_name = 'Documento de Venta'

    def __str__(self):
        return f'DocVenta #{self.nu_codi_docu_vent} – {self.ch_seri_cmprbt}-{self.ch_nume_cmprbt}'


# ---------------------------------------------------------------------------
# CIERRE DE TURNO
# ---------------------------------------------------------------------------

class CabCierreTurno(models.Model):
    """Cierre de turno de caja."""
    nu_codi_cierre = models.AutoField(primary_key=True)
    dt_fech_turno = models.DateTimeField(null=True, blank=True)
    ch_codi_turno_caja = models.CharField(max_length=2, null=True, blank=True)
    ch_codi_cajero = models.CharField(max_length=15, null=True, blank=True)
    ch_seri_cierre = models.CharField(max_length=4, null=True, blank=True)
    ch_nume_cierre = models.CharField(max_length=10, null=True, blank=True)
    nu_impo_tota_efectivo = models.DecimalField(
        max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_tota_credito = models.DecimalField(
        max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_total = models.DecimalField(
        max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_cobr_cred = models.DecimalField(
        max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_tota_ingr = models.DecimalField(
        max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_egre = models.DecimalField(
        max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_util_turno = models.DecimalField(
        max_digits=12, decimal_places=3, null=True, blank=True)
    nu_impo_otro_ingr = models.DecimalField(
        max_digits=12, decimal_places=3, null=True, blank=True)
    ch_esta_activo = models.CharField(max_length=1, null=True, blank=True)
    ch_tipo_cierre = models.CharField(max_length=1, null=True, blank=True)
    vc_obse_cierre = models.CharField(max_length=100, null=True, blank=True)
    ch_codi_garita = models.CharField(max_length=3, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'CAB_CIERRE_TURNO'
        verbose_name = 'Cierre de Turno'

    def __str__(self):
        return f'Cierre #{self.nu_codi_cierre}'


# ---------------------------------------------------------------------------
# EGRESOS E INGRESOS DE CAJA
# ---------------------------------------------------------------------------

class CabReciboEgreso(models.Model):
    """Recibo de egreso de caja."""
    nu_codi_recibo = models.AutoField(primary_key=True)
    dt_fech_egre = models.DateTimeField(null=True, blank=True)
    vc_obse_egre = models.CharField(max_length=100, null=True, blank=True)
    ch_seri_egre = models.CharField(max_length=4, null=True, blank=True)
    ch_nume_egre = models.CharField(max_length=10, null=True, blank=True)
    nu_impo_egre = models.DecimalField(
        max_digits=12, decimal_places=3, null=True, blank=True)
    ch_codi_tipo_egreso = models.ForeignKey(
        MaeTipoEgreso,
        on_delete=models.PROTECT,
        db_column='CH_CODI_TIPO_EGRESO',
        to_field='ch_codi_tipo_egreso',
        null=True, blank=True,
        related_name='recibos_egreso',
    )
    ch_codi_proveedor = models.ForeignKey(
        'maestros.MaeProveedor',
        on_delete=models.PROTECT,
        db_column='CH_CODI_PROVEEDOR',
        to_field='ch_codi_proveedor',
        null=True, blank=True,
        related_name='recibos_egreso',
    )
    ch_codi_cajero = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_garita = models.CharField(max_length=3, null=True, blank=True)
    ch_codi_turno_caja = models.CharField(max_length=2, null=True, blank=True)
    dt_fech_turno = models.DateTimeField(null=True, blank=True)
    ch_codi_autoriza = models.CharField(max_length=15, null=True, blank=True)
    ch_esta_activo = models.CharField(max_length=1, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'CAB_RECIBO_EGRESO'
        verbose_name = 'Recibo de Egreso'

    def __str__(self):
        return f'Egreso #{self.nu_codi_recibo}'


class CabReciboIngreso(models.Model):
    """Recibo de ingreso de caja."""
    nu_codi_recibo = models.AutoField(primary_key=True)
    dt_fech_ingr = models.DateTimeField(null=True, blank=True)
    vc_obse_ingr = models.CharField(max_length=100, null=True, blank=True)
    ch_seri_ingr = models.CharField(max_length=4, null=True, blank=True)
    ch_nume_ingr = models.CharField(max_length=10, null=True, blank=True)
    nu_impo_ingr = models.DecimalField(
        max_digits=12, decimal_places=3, null=True, blank=True)
    ch_codi_cliente = models.ForeignKey(
        MaeCliente,
        on_delete=models.PROTECT,
        db_column='CH_CODI_CLIENTE',
        to_field='ch_codi_cliente',
        null=True, blank=True,
        related_name='recibos_ingreso',
    )
    ch_codi_tipo_ingreso = models.ForeignKey(
        MaeTipoIngreso,
        on_delete=models.PROTECT,
        db_column='CH_CODI_TIPO_INGRESO',
        to_field='ch_codi_tipo_ingreso',
        null=True, blank=True,
        related_name='recibos_ingreso',
    )
    ch_codi_cajero = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_garita = models.CharField(max_length=3, null=True, blank=True)
    ch_codi_turno_caja = models.CharField(max_length=2, null=True, blank=True)
    dt_fech_turno = models.DateTimeField(null=True, blank=True)
    ch_esta_activo = models.CharField(max_length=1, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'CAB_RECIBO_INGRESO'
        verbose_name = 'Recibo de Ingreso'

    def __str__(self):
        return f'Ingreso #{self.nu_codi_recibo}'