# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

project_id   = attribute('project_id')
network_name = attribute('network_name')

control "gcloud" do
  title "gcloud configuration"

  describe command("gcloud compute networks subnets describe #{network_name}-subnet-01 --project=#{project_id} --region=us-west1 --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    it "logConfig should not exist" do
      expect(data).to_not include(
        "logConfig"
      )
    end
  end

  describe command("gcloud compute networks subnets describe #{network_name}-subnet-02 --project=#{project_id} --region=us-west1 --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    it "Log config should be correct" do
      expect(data).to include(
        "logConfig" => {
          "aggregationInterval" => "INTERVAL_5_SEC",
          "enable" => true,
          "flowSampling" => 0.5,
          "metadata" => "INCLUDE_ALL_METADATA"
        }
      )
    end
  end

  describe  command("gcloud compute networks subnets describe #{network_name}-subnet-03 --project=#{project_id} --region=us-west1 --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    it "Log config should be correct" do
      expect(data).to include(
        "logConfig" => {
          "aggregationInterval" => "INTERVAL_10_MIN",
          "enable" => true,
          "flowSampling" => 0.7,
          "metadata" => "INCLUDE_ALL_METADATA"
        }
      )
    end
  end
end
