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

 #1. Вычисление определителя.
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

#2. След матрицы.
 def tracix(matrix)
  n = matrix.size
  sum = 0
  
  n.times do |i|
      sum += matrix[i][i]
    end
  sum
end

#3. Ранг матрицы.
def rankix(matrix)

  return nil unless matrix.is_a?(Array) && matrix.size > 0
  return 0 if matrix.empty?
  
  
  m = matrix.map { |row| row.map(&:to_f) }
  rows = m.size
  cols = m[0].size
  
  rank = 0
  row = 0
  col = 0
  
 
  while row < rows && col < cols
   
    pivot_row = row
    while pivot_row < rows && m[pivot_row][col] == 0
      pivot_row += 1
    end
    
    if pivot_row == rows
      
      col += 1
      next
    end
    
    
    if pivot_row != row
      m[row], m[pivot_row] = m[pivot_row], m[row]
    end
    
    
    pivot_val = m[row][col]
    (col...cols).each do |j|
      m[row][j] /= pivot_val
    end
    
    
    (row+1...rows).each do |i|
      factor = m[i][col]
      (col...cols).each do |j|
        m[i][j] -= factor * m[row][j]
      end
    end
    
    rank += 1
    row += 1
    col += 1
  end
  
  rank
end

#4. Транспонирование матрицы.
def transposix(matrix)
  
  return nil unless matrix.is_a?(Array) && matrix.size > 0
  
  rows = matrix.size
  cols = matrix[0].size
  

  result = Array.new(cols) { Array.new(rows) }
  
  rows.times do |i|
    cols.times do |j|
      result[j][i] = matrix[i][j]
    end
  end
  
  result
end

#5. Обратная матрица.
def inversix(matrix)
  n = matrix.size
  
  
  return nil unless matrix.all? { |row| row.is_a?(Array) && row.size == n }
  
  
  det = determinant(matrix)
  
  if det == 0
    puts "Ошибка: определитель = 0, матрица вырожденная"
    return nil
  end
  
 
  return [[1.0 / matrix[0][0]]] if n == 1
  
  
  if n == 2
    a, b = matrix[0]
    c, d = matrix[1]
    return [
      [d / det, -b / det],
      [-c / det, a / det]
    ]
  end
  

  result = Array.new(n) { Array.new(n) }
  
  n.times do |i|
    n.times do |j|
      minor = (0...n).reject { |k| k == i }.map do |k|
        matrix[k][0...j] + matrix[k][j+1..-1]
      end
      
      cofactor = ((-1) ** (i + j)) * determinant(minor)
      
      result[j][i] = cofactor / det.to_f
    end
  end
  
  result
end

def determinant(matrix)
  n = matrix.size
  return matrix[0][0] if n == 1
  return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0] if n == 2
  
  det = 0
  n.times do |j|
    minor = (1...n).map { |i| matrix[i][0...j] + matrix[i][j+1..-1] }
    det += ((-1) ** j) * matrix[0][j] * determinant(minor)
  end
  det
end


end


# 5. Преобразования и специальные операции
module Spectrix
  class Error < StandardError; end
  # Тут писать функции
end