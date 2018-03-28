require 'particlelog/version'

require 'date'

class ParticleLog
  DEBUG     = 0
  IO        = 1
  INFO      = 2
  WARNING   = 3
  ERROR     = 4
  IMPORTANT = 5
  CRITICAL  = 7

  C_BOLD   = "\x1b[1m"
  C_RESET  = "\x1b[0m"
  C_CRESET = "\x1b[39m"

  attr_reader :name, :level_table, :color_table
  attr_accessor :level
  
  def initialize(name, level)
    @name  = name
    @level = level

    @level_table = [
      'DBG',
      ' IO',
      'INF',
      'WRN',
      'ERR',
      'IMP',
      'CRT'
    ]

    @color_table = [
      "\x1b[32m",
      "\x1b[36m",
      "\x1b[34m",
      "\x1b[33m",
      "\x1b[31m",
      "\x1b[37m",
      "\x1b[35m"
    ]
  end

  def write(message, **opts)
    level   = opts[:level]   || @level
    colored = opts[:colored] || true
    if colored
      c = @color_table[level]
      STDERR.print "#{C_BOLD+c}[#{C_CRESET+DateTime.now.strftime+C_BOLD+c} | #{C_CRESET}#{@level_table[level]+C_BOLD+c}] #{C_RESET+name+C_BOLD+c}> #{C_RESET+message}\n"
    else
      STDERR.print "[#{DateTime.now.strftime} | #{@level_table[level]}] #{name}> #{message}\n"
    end
  end

  def debug     (message, **opts) write(message, **(opts.merge level:     DEBUG)) end
  def io        (message, **opts) write(message, **(opts.merge level:        IO)) end
  def info      (message, **opts) write(message, **(opts.merge level:      INFO)) end
  def warning   (message, **opts) write(message, **(opts.merge level:   WARNING)) end
  def error     (message, **opts) write(message, **(opts.merge level:     ERROR)) end
  def important (message, **opts) write(message, **(opts.merge level: IMPORTANT)) end
  def critical  (message, **opts) write(message, **(opts.merge level:  CRITICAL)) end
  
  def inspect
    "#<ParticleLog @name=#{@name.inspect} @level=#{@level_table[@level]}>"
  end
end
