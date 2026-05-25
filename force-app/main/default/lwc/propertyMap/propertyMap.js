import { LightningElement, api, wire } from 'lwc';

import getProperty from '@salesforce/apex/PropertyController.getProperty';

export default class PropertyMap extends LightningElement {

    @api recordId;

    mapMarkers = [];

    @wire(getProperty, { propertyId: '$recordId' })
    wiredProperty({ data, error }) {

        if (data) {

            this.mapMarkers = [
                {
                    location: {
                        Latitude: data.Location__Latitude__s,
                        Longitude: data.Location__Longitude__s
                    },
                    title: data.Name
                }
            ];

        } else if (error) {

            console.error(error);
        }
    }
}