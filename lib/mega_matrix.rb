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

    # Сложение
    def +(other)
      result_data = Arifmetrix.plus(@data, extract_data(other))
      self.class.new(result_data)
    end

    def -(other)
      result_data = Arifmetrix.minus(@data, extract_data(other))
      self.class.new(result_data)
    end

    def extract_data(other)
      if other.is_a?(Matrix)
        other.data
      elsif other.is_a?(Array)
        other
      else
        raise ArgumentError, "Ожидается Matrix или Array"
      end
    end

    def to_s
      Genetrix.pprint(@data)
    end

    def to_a
      @data
    end

  end
end

# 1. Создание матриц (можно использовать как шаблон) (Для Юры)
module Genetrix
  class Error < StandardError; end


  def self.new(rows = 1, cols = 1, elem = 0)
    matrix = []

    for i in 0...rows
      row = []
      for j in 0...cols
        row << elem
      end
      matrix << row
    end

    matrix
  end

  def self.from_array(array)
    unless array.is_a?(Array) && array.all? { |row| row.is_a?(Array) }
      raise Error, "Ожидается двумерный массив"
    end

    row_size = array[0].size

    unless array.all? { |row| row.size == row_size }
      raise Error, "Все строки должны быть одинаковой длины"
    end

    # Делаем копию, чтобы избежать мутаций
    array.map(&:dup)
  end

  # Красивый вывод
  def self.pprint(matrix)
    matrix_temp = matrix.dup
    max_width = matrix_temp.flatten.map { |e| e.to_s.length }.max

    matrix_temp.map do |row|
      row.map { |e| e.to_s.rjust(max_width) }.join(" ")
    end.join("\n")
  end

  # Нулевая
  def self.zero(rows, cols = rows)
    new(rows, cols, 0)
  end

  # Единичная
  def self.identity(n)
    matrix = new(n, n, 0)

    (0...n).each do |i|
      matrix[i][i] = 1
    end

    matrix
  end

  # Заполненная значением
  def self.fill(rows, cols, value)
    new(rows, cols, value)
  end

  # Случайная
  def self.random(rows, cols, range = 0..1)
    matrix = []

    (0...rows).each do
      row = []
      (0...cols).each do
        row << rand(range)
      end
      matrix << row
    end

    matrix
  end

  # По функции (i, j)
  def self.from_function(rows, cols)
    raise Error, "Нужен блок!" unless block_given?

    matrix = []

    (0...rows).each do |i|
      row = []
      (0...cols).each do |j|
        row << yield(i, j)
      end
      matrix << row
    end

    matrix
  end

  # Диагональная
  def self.diagonal(*values)
    n = values.size
    matrix = new(n, n, 0)

    (0...n).each do |i|
      matrix[i][i] = values[i]
    end

    matrix
  end

  # Скалярная
  def self.scalar(n, value)
    matrix = new(n, n, 0)

    (0...n).each do |i|
      matrix[i][i] = value
    end

    matrix
  end

  # Матрица Гильберта
  def self.hilbert(n)
    matrix = []

    (0...n).each do |i|
      row = []
      (0...n).each do |j|
        row << 1.0 / (i + j + 1)
      end
      matrix << row
    end

    matrix
  end

  # Копия матрицы
  def self.copy(matrix)
    matrix.map(&:dup)
  end

  # Размер
  def self.shape(matrix)
    [matrix.size, matrix[0].size]
  end

  # Транспонирование (простое)
  def self.transpose(matrix)
    rows = matrix.size
    cols = matrix[0].size

    result = new(cols, rows, 0)

    (0...rows).each do |i|
      (0...cols).each do |j|
        result[j][i] = matrix[i][j]
      end
    end

    result
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
  # Тут писать функции
end