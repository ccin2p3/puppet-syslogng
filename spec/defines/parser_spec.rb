require 'spec_helper'

describe 'patterndb::parser', :type => 'define' do
  let :facts do {
    :osfamily => 'RedHat'
  } end
  let :title do
    'default'
  end
  context "Catchall" do
    it { should contain_class('Patterndb') }
    it { should contain_exec('patterndb::merge::default') }
    it { should contain_file('patterndb::file::default').with(
      'ensure' => 'present').that_notifies('Exec[patterndb::merge::default]')
    }
  end
  context "Default values (no parameters)" do
    let :params do {
      # noparams
    } end
    it {
      should contain_exec('patterndb::test::default').with(
        'command' => /patterndb\/default\.xml $/m
      )
    }
  end
  context "With optional syslog-ng module" do
    let :params do {
      :syslogng_modules => [ "foo","bar"]
    } end
    it {
      should contain_exec('patterndb::test::default').with(
        'command' => /patterndb\/default\.xml --module=foo --module=bar$/m
      )
    }
  end
  context "with two patterndbs" do
    let :pre_condition do
      'patterndb::parser { "stage1": }'
    end
    it {
      should contain_exec('patterndb::test::default').with(
        'command' => /patterndb\/default\.xml $/m
      )
    }
    it {
      should contain_exec('patterndb::test::stage1').with(
        'command' => /patterndb\/stage1\.xml $/m
      )
    }
  end
  context "With syslog-ng module in class" do
    let :pre_condition do
      'class { "patterndb": syslogng_modules => [ "foo","bar"] }'
    end
    it {
      should contain_exec('patterndb::test::default').with(
        'command' => /patterndb\/default\.xml --module=foo --module=bar$/m
      )
    }
  end
  context "With empty syslog-ng module list" do
    let :pre_condition do
      'class { "patterndb": syslogng_modules => [] }'
    end
    it {
      should contain_exec('patterndb::test::default').with(
        'command' => /patterndb\/default\.xml $/m
      )
    }
  end
  context "Without test_before_deploy" do
    let :params do {
      :test_before_deploy => false
    } end
    it { should contain_exec('patterndb::merge::default').that_notifies('Exec[patterndb::deploy::default]') }
  end
  context "With test_before_deploy" do
    let :params do {
      :test_before_deploy => true
    } end
    it { should contain_exec('patterndb::merge::default').that_notifies('Exec[patterndb::test::default]') }
    it { should contain_exec('patterndb::test::default').that_notifies('Exec[patterndb::deploy::default]') }
  end
end
