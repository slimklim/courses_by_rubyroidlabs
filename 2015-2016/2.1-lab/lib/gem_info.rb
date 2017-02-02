require 'gems'
require 'colored'

class GemInfo

  attr_reader :all_versions

  def initialize(gem_name)
    @all_versions = pull_versions(gem_name)
  end

  # main method (arr -> arr)
  def filter(options)
    match = options.map do |str_opt_operator, str_opt_version|
      operator = (str_opt_operator == '~>' ? 'tilda_operator' : 'simple_operator')
      comparing(str_opt_operator, str_opt_version, matching(operator))
    end
    (match[1] ? match[0] & match[1] : match[0]).compact
  end

  private

    # top logic (str, str, proc -> arr)
    def comparing(str_opt_operator, str_opt_version, matching)
      opt_operator = comparing_operator(str_opt_operator)
      opt_version = version_str_to_arr(str_opt_version)
      @all_versions.map do |str_version|
        if str_opt_version.include?('beta') # beta versions comparing like strings
          if str_version.include?('beta')
            x = str_version.index('beta') + 'beta'.size
            str_version if str_version.include?(str_opt_version[0...x])
          end
        else # not beta versions comparing like arrays
          version = version_str_to_arr(str_version)
          str_version if matching.call(version, opt_version, opt_operator)
        end
      end
    end

    # select logic for comparing (str -> proc)
    def matching(check)
      case check
        when 'tilda_operator'
          Proc.new do |version, opt_version|
            opt_version_tilda_max = opt_version[0...-2]
            opt_version_tilda_max << opt_version[-2] + 1
            [1, 0].include?(version <=> opt_version) &
            [-1].include?(version <=> opt_version_tilda_max)
          end
        when 'simple_operator'
          Proc.new do |version, opt_version, opt_operator|
            opt_operator.include?(version <=> opt_version)
          end
      end
    end

    # get all versions of gem (str -> arr)
    def pull_versions(gem_name)
      unless Gems.info(gem_name).class == Hash
        puts("This rubygem (#{gem_name}) could not be found")
      else
        Gems.versions(gem_name).map { |x| x['number'] }
      end
    end

    # for the comparing of versions with the help of the operator <=>
    def comparing_operator(operator)
      case operator
        when '>' then [1]
        when '<' then [-1]
        when '=' then [0]
        when '>=' then [1, 0]
        when '<=' then [-1, 0]
        when '~>' then '~>'
      end
    end

    def version_str_to_arr(str_version)
      str_version.split('.').map { |n| n.to_i }
    end

end