#!/usr/bin/env ruby

require 'graphviz'
require 'byebug'
require 'colorize'
require 'ostruct'

##
# Class representing the result to a certain experiment
class Result
  PROBLEMS = 10.upto(18)
  LEARNING_METHODS = [:lstar, :ttt].freeze
  TESTING_METHODS = [:wmethod, :randomwalk].freeze

  attr_accessor :run, :problem, :learning_method, :testing_method

  def initialize(run:, problem:, learning_method:, testing_method:)
    self.run = run
    self.problem = problem
    self.learning_method = learning_method
    self.testing_method = testing_method
  end

  def method
    "#{learning_method} + #{testing_method}"
  end

  def problem=(problem)
    problem = PROBLEMS.include?(problem.to_i) ? problem.to_i : 10
    @problem = problem
  end

  def exists?
    File.exist?(dot_file_path)
  end

  def dot_file
    File.new(dot_file_path)
  end

  private

  def dot_file_path
    "#{result_directory_path}/model.dot"
  end

  def result_directory_path
    "../experiment-results/run-#{run}/problem#{problem}-#{learning_method}-#{testing_method}"
  end
end

##
# Class implementing the solution to a certain problem
class Solution
  PROBLEMS = 10.upto(18)

  attr_accessor :problem

  def initialize(problem:)
    problem = PROBLEMS.include?(problem.to_i) ? problem.to_i : 10
    self.problem = problem
  end

  def file
    File.new(file_path)
  end

  private

  def file_path
    "../rers-solutions/Problem#{problem}-solutions.txt"
  end
end

##
# Class implementing the logic to compare a result against a solution
class Comparison
  attr_accessor :solution, :result, :comparison_result

  def initialize(solution:, result:)
    self.solution = solution
    self.result = result
  end

  def compare
    labels = []
    GraphViz.parse(result.dot_file.path) do |g|
      g.each_edge do |e|
        labels << e[:label]
      end
    end
    found_states = labels.map do |label|
      match = /[0-9]+ \/ ERROR ([0-9]+);/.match(label.to_s)
      match[1].to_i unless match.nil?
    end.compact.uniq

    all_states= []
    solution.file.each_line do |line|
      first_token = line.split(' ').first.to_s
      match = /error_([0-9]+)/.match(first_token)
      next if match.nil?
      all_states << match[1].to_i
    end
    all_states = all_states.compact.uniq

    missed_states = all_states - found_states

    recall = 1.0 - (missed_states.size.to_f / all_states.size.to_f)

    self.comparison_result = OpenStruct.new({
      found_states: found_states,
      missed_states: missed_states,
      all_states: all_states,
      recall: recall
    })
  end

  def print_comparison_result
    return if comparison_result.nil?
    puts textual_report
  end

  def csv_row
    [result.problem, result.method, comparison_result.recall]
  end

  private

  def textual_report
    [
      "Problem #{result.problem} (#{result.learning_method} + #{result.testing_method})".cyan,
      "Found states: #{comparison_result.found_states.join(',').green}",
      "Missed states: #{comparison_result.missed_states.join(',').red}",
      "Reachable states: #{comparison_result.all_states.map { |x| comparison_result.found_states.include?(x) ? x.to_s.green : x.to_s.red }.join(',')}",
      "Recall: #{"#{comparison_result.recall * 100}%".yellow}",
      '', ''
    ].join "\n"
  end
end

def analyze_run(run)
  Result::PROBLEMS.each do |problem|
    solution = Solution.new(problem: problem)

    # Expect advanced testing methods to be run only on smallest problem instance
    testing_methods = problem == 10 ? Result::TESTING_METHODS : [:randomwalk]

    testing_methods.each do |testing_method|
      Result::LEARNING_METHODS.each do |learning_method|
        result = Result.new(
          run: run,
          problem: problem,
          learning_method: learning_method,
          testing_method: testing_method
        )
        next unless result.exists?

        comparison = Comparison.new(result: result, solution: solution)
        comparison.compare
        comparison.print_comparison_result
      end
    end
  end
end

analyze_run(1522614581)
