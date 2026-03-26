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

# 1. Создание матриц (можно использовать как шаблон) (Юра)
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
    matrix_temp = matrix.respond_to?(:to_a) ? matrix.to_a : matrix
    max_width = matrix_temp.flatten.map { |e| e.to_s.length }.max

    matrix_temp.map do |row|
      row.map { |e| e.to_s.rjust(max_width) }.join(" ")
    end.join("\n")

  end
end


# 2. Доступ к элементам и изменение (Тёма)
module Accesstrix
  class Error < StandardError; end
  # Тут писать функции
end


# 3. Арифметические операции (Миша)
module Arifmetrix
  class Error < StandardError; end

  def self.plus(matrix_1, matrix_2)
    check_sizes(matrix_1, matrix_2)

    rows = matrix_1.size
    cols = matrix_1[0].size

    result = Genetrix.new(rows, cols, 0)   # ← создаём нулевую матрицу

    (0...rows).each do |i|
      (0...cols).each do |j|
        result[i][j] = matrix_1[i][j] + matrix_2[i][j]
      end
    end
    result
  end

  def self.minus(matrix_1, matrix_2)
    check_sizes(matrix_1, matrix_2)

    rows = matrix_1.size
    cols = matrix_1[0].size

    result = Genetrix.new(rows, cols, 0)

    (0...rows).each do |i|
      (0...cols).each do |j|
        result[i][j] = matrix_1[i][j] - matrix_2[i][j]
      end
    end
    result
  end

  def self.multi_scalar(matrix, scalar)
    raise Error, "Скаляр должен быть числом" unless scalar.is_a?(Numeric)

    rows = matrix.size
    cols = matrix[0].size

    result = Genetrix.new(rows, cols, 0)

    (0...rows).each do |i|
      (0...cols).each do |j|
        result[i][j] = matrix[i][j] * scalar
      end
    end
    result
  end

  def self.multi_matrix(matrix_1, matrix_2)
    # Проверка совместимости: число столбцов первой = число строк второй
    if matrix_1[0].size != matrix_2.size
      raise Arifmetrix::Error, "Несовместимые размеры для умножения"
    end

    rows = matrix_1.size
    cols = matrix_2[0].size
    common = matrix_1[0].size  # общая размерность

    # Создаём нулевую матрицу результата через Genetrix
    result = Genetrix.new(rows, cols, 0)

    # Основные циклы умножения
    (0...rows).each do |i|
      (0...cols).each do |j|
        sum = 0
        (0...common).each do |k|
          sum += matrix_1[i][k] * matrix_2[k][j]
        end
        result[i][j] = sum
      end
    end

    result
  end

  private

  def self.check_sizes(matrix_1, matrix_2)
    if matrix_1.size != matrix_2.size || matrix_1[0].size != matrix_2[0].size
      raise Error, "Bad sizes!"
    end
  end

end


# 4. Линейная алгебра и численные методы (Толя)
module Linetrix
  class Error < StandardError; end
  # Тут писать функции
end


# 5. Преобразования и специальные операции (Давид)
module Spectrix
  class Error < StandardError; end
  # Тут писать функции
end