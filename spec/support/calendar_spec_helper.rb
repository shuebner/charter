module CalendarSpecHelper
  N_MONTHS_PER_YEAR = 12

  def months_between(d1, d2)
    d1, d2 = [d1, d2].minmax

    n_months = (d2.month - d1.month) + (d2.year - d1.year) * N_MONTHS_PER_YEAR
    (d1.month .. (d1.month + n_months)).each_with_object([]) do |month, month_names_array|
      month_names_array << "#{I18n.t('date.month_names')[((month - 1) % N_MONTHS_PER_YEAR) + 1]} #{d1.year + ((month - 1) / N_MONTHS_PER_YEAR)}"
    end
  end
end