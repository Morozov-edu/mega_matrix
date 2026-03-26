# frozen_string_literal: true

require_relative "mega_matrix/version"

module MegaMatrix
  class Error < StandardError; end

  def self.help # Не забыть описать!!!
    puts "Тут и так все понято"
  end
  
  class Matrix
    attr_reader :data

    # Инициализация: принимает двумерный массив
    def initialize(data)
      raise ArgumentError, "Данные должны быть двумерным массивом" unless data.is_a?(Array) && data.all? { |row| row.is_a?(Array) }
      @data = data
    end

    # map – поэлементное преобразование с возвратом новой матрицы
    def map(&block)
      new_data = @data.map do |row|
        row.map(&block)
      end
      self.class.new(new_data)
    end

    # flatten – превращает матрицу в одномерный массив
    def flatten
      result = []
      @data.each do |row|
        result.concat(row)
      end
      result
    end

    # reshape(rows, cols) – изменяет форму матрицы без изменения данных
    def reshape(rows, cols)
      flat = flatten
      expected = rows * cols
      
      if flat.size != expected
        raise Error, "Невозможно изменить форму: #{flat.size} элементов в #{rows}x#{cols} (нужно #{expected})"
      end
      
      new_data = Array.new(rows) { |i| flat[i * cols, cols] }
      self.class.new(new_data)
    end

    # transpose! – in-place транспонирование (для квадратных)
    def transpose!
      n = @data.size
      
      # Проверяем, что матрица квадратная
      @data.each_with_index do |row, i|
        raise Error, "Строка #{i} не является массивом" unless row.is_a?(Array)
        raise Error, "Матрица не квадратная: ожидается #{n}x#{n}, но строка #{i} имеет размер #{row.size}" if row.size != n
      end
      
      (0...n).each do |i|
        (i+1...n).each do |j|
          @data[i][j], @data[j][i] = @data[j][i], @data[i][j]
        end
      end
      
      self
    end

    # augment(other) – присоединяет матрицу справа (расширенная матрица)
    def augment(other)
      unless other.is_a?(Matrix)
        raise Error, "Аргумент должен быть объектом MegaMatrix::Matrix"
      end
      
      # Проверяем, что количество строк совпадает
      if @data.size != other.data.size
        raise Error, "Количество строк не совпадает: #{@data.size} vs #{other.data.size}"
      end
      
      # Объединяем строки
      new_data = []
      @data.each_with_index do |row, i|
        new_data << row + other.data[i]
      end
      
      self.class.new(new_data)
    end

    def to_s
      Genetrix.pprint(@data)
    end

    def to_a
      @data
    end
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
  # Тут писать функции
end


# 5. Преобразования и специальные операции
module Spectrix
  class Error < StandardError; end


  #map – поэлементное преобразование с возвратом новой матрицы.
  # Функция map для поэлементного преобразования матрицы
  def self.map(matrix, &block)
    return matrix.map(&block) if matrix.respond_to?(:map)
    matrix.map { |row| row.map(&block) }
  end



  #flatten – превращает матрицу в одномерный массив.
  def self.flatten(matrix)
    raise Error, "Аргумент должен быть массивом" unless matrix.is_a?(Array)
    matrix.inject([]) { |result, element| result + Array(element) }
  end


  #reshape(rows, cols) – изменяет форму матрицы без изменения данных.
  def self.reshape(matrix, rows, cols)
    raise Error, "Аргумент должен быть массивом" unless matrix.is_a?(Array)
    
    flat = flatten(matrix)
    expected = rows * cols
    
    if flat.size != expected
      raise Error, "Невозможно изменить форму: #{flat.size} элементов в #{rows}x#{cols} (нужно #{expected})"
    end
    
    Array.new(rows) { |i| flat[i * cols, cols] }
  end



  #transpose! – in-place транспонирование (для квадратных).
   def self.transpose!(matrix)
    raise Error, "Аргумент должен быть массивом" unless matrix.is_a?(Array)
    
    n = matrix.size
    # Проверяем, что каждый ряд - массив и размер равен n
    matrix.each_with_index do |row, i|
      raise Error, "Строка #{i} не является массивом" unless row.is_a?(Array)
      raise Error, "Матрица не квадратная: ожидается #{n}x#{n}, но строка #{i} имеет размер #{row.size}" if row.size != n
    end
    
    (0...n).each do |i|
      (i+1...n).each do |j|
        matrix[i][j], matrix[j][i] = matrix[j][i], matrix[i][j]
      end
    end
    
    matrix
  end



  #augment(other) – присоединяет матрицу справа (расширенная матрица).
  def self.augment(matrix, other)
    unless matrix.is_a?(Array) && matrix.all? { |row| row.is_a?(Array) }
      raise Error, "Первый аргумент должен быть матрицей (массивом массивов)"
    end
    
    unless other.is_a?(Array) && other.all? { |row| row.is_a?(Array) }
      raise Error, "Второй аргумент должен быть матрицей (массивом массивов)"
    end
    
    # Проверяем, что количество строк совпадает
    if matrix.size != other.size
      raise Error, "Количество строк не совпадает: #{matrix.size} vs #{other.size}"
    end
  
    # Объединяем строки
    result = []
    matrix.each_with_index do |row, i|
      result << row + other[i]
    end
    
    result
  end

end

