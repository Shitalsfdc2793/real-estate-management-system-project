import { LightningElement, api, wire } from 'lwc';

import { loadScript } from 'lightning/platformResourceLoader';

import jsPDFLibrary from '@salesforce/resourceUrl/jspdf';

import getLeaseAgreement
from '@salesforce/apex/LeaseAgreementController.getLeaseAgreement';

export default class LeaseAgreementPdf extends LightningElement {

    @api recordId;

leaseRecord;

jsPdfInitialized = false;

// Fetch Lease Data

@wire(getLeaseAgreement, { leaseId: '$recordId' })
wiredLease({ data, error }) {

    if(data) {

        this.leaseRecord = data;

    } else if(error) {

        console.error(error);
    }
}

// Load jsPDF Library

renderedCallback() {

    if(this.jsPdfInitialized) {
        return;
    }

    this.jsPdfInitialized = true;

    loadScript(
        this,
        jsPDFLibrary + '/jspdf.umd.min.js'
    )
    .then(() => {

        console.log('jsPDF Loaded');

    })
    .catch(error => {

        console.error(error);
    });
}

// Generate PDF

generatePdf() {

    const { jsPDF } = window.jspdf;

    const doc = new jsPDF();

    doc.setFontSize(18);

    doc.text('Lease Agreement', 20, 20);

    doc.setFontSize(12);

    doc.text(
        'Lease Number: ' +
        this.leaseRecord.Name,
        20,
        40
    );

    doc.text(
        'Tenant Name: ' +
        this.leaseRecord.Tenant__r.Name,
        20,
        50
    );

    doc.text(
        'Property Name: ' +
        this.leaseRecord.Property__r.Name,
        20,
        60
    );

    doc.text(
        'Monthly Rent: ₹' +
        this.leaseRecord.Agreed_Monthly_Rent__c,
        20,
        70
    );

    doc.text(
        'Start Date: ' +
        this.leaseRecord.Start_Date__c,
        20,
        80
    );

    doc.text(
        'End Date: ' +
        this.leaseRecord.End_Date__c,
        20,
        90
    );

    doc.text(
        'Terms:',
        20,
        110
    );

    doc.text(
        this.leaseRecord.Terms__c,
        20,
        120
    );

    // Download PDF

    doc.save('LeaseAgreement.pdf');
}
}