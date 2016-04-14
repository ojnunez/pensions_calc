class DashboardController < ApplicationController
  layout 'application'

  def index
    #Params
    @salario = params[:wage].to_f rescue 0
    @gender = params[:gender].to_s
    
    #Constantes
    @esquema_actual = 11.27
    @porcentaje_esquema_actual = 12.5 #cambiar nombre variable
    @supuesto_rentabilidad_actual = 0.033 #3.3%
    @tasa_contribucion_cuenta_reforma = 0.111 #11.1%
    @comision_seguros_reforma = 0.019 #1.9%
    @dos_salarios_minimos = 251.7*2
    @capital_tecnico_necesario = @gender == "hombre" ? 11.2718536995587 : 13.4152856651179

    #Esquema Actual
    @valor_1a = 0.108*12*@salario
    @rentabilidad_neta_actual = @supuesto_rentabilidad_actual*@salario
    @valor_final_actual = @valor_1a
    @rentabilidad_neta_en_el_tiempo_actual = @rentabilidad_neta_actual
    25.times do
      @rentabilidad_neta_en_el_tiempo_actual = @valor_final_actual * @supuesto_rentabilidad_actual
      @valor_final_actual = @valor_final_actual + @valor_1a + @rentabilidad_neta_en_el_tiempo_actual
    end
    @pension_minima_con_subsidio = (@valor_final_actual / (@capital_tecnico_necesario*@porcentaje_esquema_actual)) < 207.6 ? 207.6 : @valor_final_actual / (@capital_tecnico_necesario*@porcentaje_esquema_actual)
    @pension_segun_ahorros_actual = @capital_tecnico_necesario*@porcentaje_esquema_actual
    @comisiones_pagadas_a_afp_actual = 0.022*@salario*12*25
    @anios_de_pension_a_recibir = ((@valor_final_actual/@pension_minima_con_subsidio)/@porcentaje_esquema_actual).round(0)
    @anios_financiaria_estado = @gender == "hombre" ? 17-@anios_de_pension_a_recibir : 29-@anios_de_pension_a_recibir
    @porcentaje_respecto_salario_actual = @pension_segun_ahorros_actual/@salario
    @financiamiento_asumido_por_estado_actual = @anios_financiaria_estado * 207.6 * @porcentaje_esquema_actual
    @dinero_para_gobierno_actual = (@financiamiento_asumido_por_estado_actual / @valor_final_actual).round(1)

    #Esquema segun Reforma
    @valor_1r = @salario <= @dos_salarios_minimos ? 0 : (@salario - @dos_salarios_minimos)*@tasa_contribucion_cuenta_reforma
    @rentabilidad_neta_reforma = @supuesto_rentabilidad_actual * @valor_1r
    @valor_final_reforma = @valor_1r
    @rentabilidad_neta_en_el_tiempo_reforma = @rentabilidad_neta_reforma
    25.times do
      @valor_final_reforma = @valor_final_reforma + @valor_1r + @rentabilidad_neta_en_el_tiempo_reforma
      @rentabilidad_neta_en_el_tiempo_reforma = @valor_final_reforma * @supuesto_rentabilidad_actual
    end
    @pension_aproximada_reforma = @valor_final_reforma / @capital_tecnico_necesario
    @comisiones_pagadas_a_afp_reforma = @salario > @dos_salarios_minimos ? ((@comision_seguros_reforma*12*25*(@salario-@dos_salarios_minimos))+(0.01*@dos_salarios_minimos*12*25)) : (0.01*@salario*12*25)
    @porcentaje_respecto_salario_reforma = @pension_aproximada_reforma / @salario
    @financiamiento_asumido_por_estado_reforma = @gender == "hombre" ? 17*207.6*@porcentaje_esquema_actual : 29*207.6*@porcentaje_esquema_actual
    @dinero_para_gobierno_reforma = (@financiamiento_asumido_por_estado_reforma / @valor_final_actual).round(1)
    #=IF(C5="Hombre";17*207,6*12,5;29*207,6*12,5)
    #IF($'Calculadora de pensión'.$C$4>$'Esquema de Reforma'.$E$5;
      #($'Esquema de Reforma'.$E$4*12*25*($C$4-$'Esquema de Reforma'.$E$5))+(0,01*$'Esquema de Reforma'.$E$5*12*25);
      #0,01*$'Calculadora de pensión'.$C$4*12*25)
    puts "====#{@valor_1r}==#{@valor_final_reforma}"
  end

end

