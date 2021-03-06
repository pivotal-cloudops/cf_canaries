require 'spec_helper'
require 'cf_canaries/cli'

module CfCanaries
  describe Cli do
    let(:args) do
      %w(
        --number-of-zero-downtime-apps=20
        --number-of-instances-canary-instances=2
        --app-domain=my_app_domain.com
        --target=api.my_app_domain.com
        --username=my_username
        --password=my_password
        --organization=my_org
        --space=my_space
      )
    end

    subject(:cli) { Cli.new(args) }

    describe 'required options' do
      it 'successfully validates when all the required args are present' do
        expect(cli).to validate_successfully
      end

      it 'fails when --number-of-zero-downtime-apps is not specified' do
        args.delete_if { |s| s.match /number-of-zero-downtime-apps/ }
        expect(cli).to fail_validation(/--number-of-zero-downtime-apps is required/)
      end

      it 'fails when --number-of-instances-canary-instances is not specified' do
        args.delete_if { |s| s.match /--number-of-instances-canary-instances/ }
        expect(cli).to fail_validation(/--number-of-instances-canary-instances is required/)
      end

      it 'fails when --app-domain is not specified' do
        args.delete_if { |s| s.match /--app-domain/ }
        expect(cli).to fail_validation(/--app-domain is required/)
      end

      it 'fails when --target is not specified' do
        args.delete_if { |s| s.match /--target/ }
        expect(cli).to fail_validation(/--target is required/)
      end

      it 'fails when --username is not specified' do
        args.delete_if { |s| s.match /--username/ }
        expect(cli).to fail_validation(/--username is required/)
      end

      it 'fails when --password is not specified' do
        args.delete_if { |s| s.match /--password/ }
        expect(cli).to fail_validation(/--password is required/)
      end

      it 'fails when --organization is not specified' do
        args.delete_if { |s| s.match /--organization/ }
        expect(cli).to fail_validation(/--organization is required/)
      end

      it 'fails when --space is not specified' do
        args.delete_if { |s| s.match /--space/ }
        expect(cli).to fail_validation(/--space is required/)
      end
    end

    describe 'parsed options' do
      it 'exposes options matching the command line arguments' do
        expect(cli).to validate_successfully
        opts = cli.options
        expect(opts.number_of_zero_downtime_apps).to eq(20)
        expect(opts.number_of_instances_canary_instances).to eq(2)

        expect(opts.app_domain).to eq('my_app_domain.com')
        expect(opts.target).to eq('api.my_app_domain.com')
        expect(opts.username).to eq('my_username')
        expect(opts.password).to eq('my_password')
        expect(opts.organization).to eq('my_org')
        expect(opts.space).to eq('my_space')
      end

      it 'exposes default options for non-required command line arguments' do
        expect(cli).to validate_successfully
        opts = cli.options
        expect(opts.dry_run).to eq(false)
        expect(opts.number_of_instances_per_app).to eq(1)
        expect(opts.cf_command).to eq('cf')
        expect(opts.skip_ssl_validation).to eq(false)
        expect(opts.diego).to eq(false)
      end

      describe 'overridden, non-required options' do
        it 'exposes overridden --dry-run' do
          args << '--dry-run'

          expect(cli).to validate_successfully
          opts = cli.options
          expect(opts.dry_run).to eq(true)
        end

        it 'exposes overridden --number-of-instances-per-app' do
          args << '--number-of-instances-per-app=2'

          expect(cli).to validate_successfully
          opts = cli.options
          expect(opts.number_of_instances_per_app).to eq(2)
        end

        it 'exposes overridden --cf-command' do
          args << '--cf-command=my-cf'

          expect(cli).to validate_successfully
          opts = cli.options
          expect(opts.cf_command).to eq('my-cf')
        end

        it 'exposes the skip-ssl-validation flag' do
          args << '--skip-ssl-validation'

          expect(cli).to validate_successfully
          opts = cli.options
          expect(opts.skip_ssl_validation).to eq(true)
        end

        it 'exposes the diego flag' do
          args << '--diego'

          expect(cli).to validate_successfully
          opts = cli.options
          expect(opts.diego).to eq(true)
        end
      end
    end
  end
end
