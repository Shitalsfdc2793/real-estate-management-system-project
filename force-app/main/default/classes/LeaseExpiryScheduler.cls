global class LeaseExpiryScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {

        sendThirtyDayReminder();

        sendOneDayReminder();
    }

    // 30 Days Reminder

    public static void sendThirtyDayReminder() {

        List<Lease_Agreement__c> leases = [

            SELECT Id,
                   Name,
                   End_Date__c,
                   Tenant__r.Name,
                   Tenant__r.Email__c
            FROM Lease_Agreement__c
            WHERE End_Date__c = :System.today().addDays(30)
        ];

        sendEmails(
            leases,
            'Lease Expiry Reminder - 30 Days Left'
        );
    }

    // 1 Day Reminder

    public static void sendOneDayReminder() {

        List<Lease_Agreement__c> leases = [

            SELECT Id,
                   Name,
                   End_Date__c,
                   Tenant__r.Name,
                   Tenant__r.Email__c
            FROM Lease_Agreement__c
            WHERE End_Date__c = :System.today().addDays(1)
        ];

        sendEmails(
            leases,
            'Lease Expiry Reminder - 1 Day Left'
        );
    }

    // Common Email Method

    public static void sendEmails(
        List<Lease_Agreement__c> leases,
        String subject
    ) {

        List<Messaging.SingleEmailMessage> emails =
            new List<Messaging.SingleEmailMessage>();

        for(Lease_Agreement__c lease : leases) {

            if(lease.Tenant__r.Email__c != null) {

                Messaging.SingleEmailMessage email =
                    new Messaging.SingleEmailMessage();

                email.setToAddresses(
                    new List<String>{
                        lease.Tenant__r.Email__c
                    }
                );

                email.setSubject(subject);

                email.setPlainTextBody(

                    'Dear ' +
                    lease.Tenant__r.Name +
                    ',\n\n' +

                    'Your lease agreement "' +
                    lease.Name +
                    '" will expire on ' +
                    String.valueOf(lease.End_Date__c) +
                    '.\n\n' +

                    'Please contact property management for renewal.\n\n' +

                    'Thank You'
                );

                emails.add(email);
            }
        }

        if(!emails.isEmpty()) {

            Messaging.sendEmail(emails);
        }
    }
}