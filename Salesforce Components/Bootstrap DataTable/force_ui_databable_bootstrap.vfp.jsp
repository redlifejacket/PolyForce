<apex:page contentType="text/plain">
    <link rel="import" href="{!URLFOR($Resource.MobileUIElements, 'dist/mobile-ui-elements.html')}"/>
    <polymer-element name="data-table" attributes="sobject fields orderby limitresults tableclasses theme" noscript="true">               
        <template>
            <!-- Import bootstrap through CDN -->
            <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css"/>
            <force-sobject-collection id="obj_collection" sobject="{{sobject}}" querytype="soql" query="{{query}}" on-sync="{{updateChart}}"></force-sobject-collection>
            <table class="table {{tableclasses}}" border="0" cellpadding="0" cellspacing="0">
                <thead > 
                    <tr > 
                        <template repeat="{{ field in fieldsReady }}">
                            <th >{{field}}</th>
                        </template>
                    </tr>
                </thead>
                <tbody id="contactTableBody">
                    <template repeat="{{ rec in data }}">
                        <tr class="{{theme}}">
                            <template repeat="{{ field in fieldsReady }}">                            
                                <td >{{rec[field]}}</td>
                            </template>
                        </tr>
                    </template>
                </tbody>     
            </table>
        </template>
        <script>
        Polymer('data-table', {
            observe: {
                sobject: 'ready',
                fields : 'updateFiledsArray', 
                limitResults : 'ready', 
                orderby : 'ready'
            },
            ready: function() {
                this.query = "Select " + this.fields + " from " + this.sobject + " ORDER BY "+ this.orderby+ " limit " + this.limitresults ;
            },
            
            updateFiledsArray: function() {
                var tempArray = this.fields.split(','),
                    arrayLength = tempArray.length,
                    i;
                
                this.fieldsReady = [];
                
                for (i = 0; i < arrayLength; i++) {
                    this.fieldsReady.push(tempArray[i].trim());
                }
                
                this.ready();
            },
            
            updateChart: function() {
                var data = [];
                this.$.obj_collection.collection.models.forEach(function(model) {
                    data.push(model.attributes);
                });
                this.data = data;
                
            },
            created: function() {
                this.fieldsReady = [];
            }
        });
        </script>
    </polymer-element>
    <script>
    document.addEventListener('WebComponentsReady', function() {
        SFDC.launch({
            accessToken: "{!$API.Session_ID}",
            instanceUrl: "https://" + window.location.hostname
        });
    });
    </script>
</apex:page>