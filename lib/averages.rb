module Averages
  def enrollment_count
    count = 0

    sections.each do |section|
      count += section.instruction_enroll_count
    end
    count
  end

  def average_instruction
    average = []

    sections.each do |section|
      average.push(section.instruction)
    end
    (average.inject{ |sum, el| sum + el }.to_f / average.size).round(2)
  end

  def average_course
    average = []

    sections.each do |section|
      average.push(section.course)
    end
    (average.inject{ |sum, el| sum + el }.to_f / average.size).round(2)
  end

  def average_learned
    average = []

    sections.each do |section|
      average.push(section.learned)
    end
    (average.inject{ |sum, el| sum + el }.to_f / average.size).round(2)
  end

  def average_stimulated
    average = []

    sections.each do |section|
      average.push(section.stimulated)
    end
    (average.inject{ |sum, el| sum + el }.to_f / average.size).round(2)
  end

  def average_challenged
    average = []

    sections.each do |section|
      average.push(section.challenged)
    end
    (average.inject{ |sum, el| sum + el }.to_f / average.size).round(2)
  end

  def average_hours
    average = []

    sections.each do |section|
      average.push(section.hours)
    end
    (average.inject{ |sum, el| sum + el }.to_f / average.size).round(2)
  end
end