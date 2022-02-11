class CampaignModel {
  String campaignName = "";
  String campaignDescription = "";
  String campaignCity = "";
  String campaignAddress = "";
  String campaignStartDate = "";

  setCampaignName(newcampaignName) {
    this.campaignName = newcampaignName;
  }

  setDescription(newcampaignDescription) {
    this.campaignDescription = newcampaignDescription;
  }

  setCityName(newcampaignCity) {
    this.campaignCity = newcampaignCity;
  }

  setStartingDate(campaignStartDate) {
    this.campaignStartDate = campaignStartDate;
  }

  setAddress(newccampaignAddress) {
    this.campaignAddress = newccampaignAddress;
  }

  get getCampaignName => campaignName;

  get getDescription => campaignDescription;

  get getCity => campaignCity;

  get getStartDate => campaignStartDate;

  get getAddress => campaignAddress;
}
