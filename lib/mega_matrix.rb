# frozen_string_literal: true

require_relative "mega_matrix/version"

module MegaMatrix
  class Error < StandardError; end

  def self.help # Не забыть описать!!!
    puts "Тут и так все понято"
  end
end

# 1. Создание матриц (можно использовать как шаблон)
module Genetrix
  class Error < StandardError; end

  # Генерация матрицы
  def self.new(rows = 1, colums = 1, elem = 0)
    matrix = []

    for i in 0...rows
      new_row = []
      for j in 0...colums
        new_row << elem
      end
      matrix << new_row
    end

    matrix
  end

  # Красивый вывод
  def self.pprint(matrix)
    matrix_temp = matrix.dup
    max_width = matrix_temp.flatten.map { |e| e.to_s.length }.max

    matrix_temp.map do |row|
      row.map { |e| e.to_s.rjust(max_width) }.join(" ")
    end.join("\n")

  end
end


# 2. Доступ к элементам и изменение
module Accesstrix
  class Error < StandardError; end
  # Тут писать функции
end


# 3. Арифметические операции
module Arifmetrix
  class Error < StandardError; end
  # Тут писать функции
end


# 4. Линейная алгебра и численные методы
module Linetrix
  class Error < StandardError; end

 def detrix(matrix)
  n = matrix.size
  return nil unless matrix.is_a?(Array) && n > 0
  return nil unless matrix.all? { |row| row.is_a?(Array) && row.size == n }
  
  return matrix[0][0] if n == 1
  
  if n == 2
    return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]
  end
  
  det = 0
  n.times do |j|
    minor = (1...n).map do |i|
      matrix[i][0...j] + matrix[i][j+1..-1]
    end
    
    # Вычисляем знак
    sign = j.even? ? 1 : -1
    
    # Рекурсивный вызов
    det += sign * matrix[0][j] * determinant(minor)
  end
  
  det
end

end


# 5. Преобразования и специальные операции
module Spectrix
  class Error < StandardError; end
  # Тут писать функции
end