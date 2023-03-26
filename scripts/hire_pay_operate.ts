import { ethers } from "hardhat";

(async()=>{
    try {
        const [owner, einar, gunnar] = await ethers.getSigners();

        const Offer = await ethers.getContractFactory("EmploymentOffer");
        const offer = await Offer.deploy(owner.address);

        const Contract = await ethers.getContractFactory("EmploymentContract");
        const contract = await Contract.deploy(owner.address, offer.address);

        const Company = await ethers.getContractFactory("Company");
        const company = await Company.deploy(contract.address, offer.address);
        
        await offer.mint(einar.address, "Einar", "Einar", "Einar", "ProjectManager", 30000);
        await offer.mint(gunnar.address, "Gunnar", "Gunnar", "Gunnar", "BackEndDeveloper", 30000);

        await contract.connect(einar).mint(einar.address);
        await offer.connect(einar).burn(einar.address);

        await company.connect(einar).mintISK();


        await contract.connect(gunnar).mint(gunnar.address);
        await offer.connect(gunnar).burn(gunnar.address);

        await company.connect(gunnar).mintISK();

        const ISK = await ethers.getContractFactory("ISK");
        const iskAddress = await company.isk();
        const isk = ISK.attach(iskAddress);
        await isk.connect(einar).transfer(gunnar.address, 1000);
        const balance = await isk.balanceOf(gunnar.address);
        console.log(balance);
    } catch (ex) {
        console.error(ex);
    }
})();
