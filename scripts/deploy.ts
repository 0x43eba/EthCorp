import { ethers } from "hardhat";

(async()=>{
    try {
        const [owner] = await ethers.getSigners();

        const Offer = await ethers.getContractFactory("EmploymentOffer");
        const offer = await Offer.deploy(owner.address);
        console.log(offer.address);

        const Contract = await ethers.getContractFactory("EmploymentContract");
        const contract = await Contract.deploy(owner.address, offer.address);
        console.log(contract.address);

        const Company = await ethers.getContractFactory("Company");
        const company = await Company.deploy(contract.address, offer.address);
        console.log(company.address);

        console.log(owner.address);

    } catch (ex) {
        console.error(ex);
    }
})();
