class BmrCalculator
  def initialize(patient)
    @patient = patient
  end

  def calculate(formula_key)
    case formula_key.to_s.downcase
    when "mifflin", "mifflin-st-jeor", "mifflin_st_jeor", "mifflin_san_jeor"
      mifflin
    when "harris", "harris-benedict", "harris_benedict"
      harris_benedict
    else
      raise ArgumentError, 'Unsupported formula. Use "mifflin" or "harris"'
    end
  end

  private

  def weight_kg
    @patient.weight.to_f
  end

  def height_cm
    @patient.height.to_f
  end

  def age
    @patient.age || 0
  end

  def gender_offset
    g = @patient.gender.to_s.downcase
    return 5 if g == "male"
    return -161 if g == "female"
    0
  end

  def mifflin
    raise ArgumentError, "height and weight required" if weight_kg.zero? ||
                                                         height_cm.zero?
    (10 * weight_kg) + (6.25 * height_cm) - (5 * age) + gender_offset
  end

  def harris_benedict
    raise ArgumentError, "height and weight required" if weight_kg.zero? ||
                                                         height_cm.zero?
    if @patient.gender.to_s.downcase == "male"
      88.362 + (13.397 * weight_kg) + (4.799 * height_cm) - (5.677 * age)
    else
      447.593 + (9.247 * weight_kg) + (3.098 * height_cm) - (4.330 * age)
    end
  end
end
