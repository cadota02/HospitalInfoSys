<%@ Page Title="" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="Contacts.aspx.cs" Inherits="HospitalInfoSys.Admin.Contacts" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
      <style>
        body {
            background-color: #f8f8f8;
        }
        .login-container {
            max-width: 900px;
            margin: 100px auto;
            padding: 30px;
            background: #fff;
            border-radius: 5px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        .login-container h2 {
            text-align: center;
            margin-bottom: 20px;
        }
         /* Modal Background */
    .modal {
        display: none;
        position: fixed;
        z-index: 1;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
    }

    /* Modal Content */
    .modal-content {
        background-color: white;
        padding: 20px;
        border-radius: 5px;
        width: 400px;
        margin: 10% auto;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }

    /* Close Button */
    .close {
        float: right;
        font-size: 20px;
        cursor: pointer;
    }

    /* Input Styling */
    .form-control {
        width: 100%;
    
        margin: 5px 0;
    }
    </style>
    <div class="container">
        <div class="login-container">
        <h4 class="text-center text-primary">Contacts/Messages</h4>
        <hr>
            <div class="row">
                <div class="col-md-12">
                   <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>
                                             <div class="form-group row">
                               
                                                <div class="col-sm-4">
                                       
                                                 <asp:TextBox ID="txt_search" CssClass="form-control form-control-sm" placeholder="Enter keyword" runat="server"></asp:TextBox>
                                                </div>
                                              
                                                <div class="col-sm-8">
                                                 
                                                 <asp:LinkButton ID="btn_filter" CssClass=" btn btn-info" 
                                                         runat="server" onclick="btn_filter_Click" > Search</asp:LinkButton>
                                                          <asp:LinkButton ID="btn_reset" CssClass="btn btn-default" 
                                                         runat="server" onclick="btn_reset_Click" BackColor="#999999">Refresh</asp:LinkButton>
                                                      
                                                </div>
                                             
                                                  </div>
                       <div class="table-responsive">
                           <asp:GridView ID="gv_masterlist" runat="server" 
                              CssClass="table  table-bordered table-sm  table-hover" 
                              AutoGenerateColumns="false" AllowPaging="true"
                              OnPageIndexChanging="OnPaging" PageSize="10" 
                            GridLines="None" PagerSettings-Mode="NumericFirstLast"
                              HeaderStyle-HorizontalAlign="Center" HeaderStyle-VerticalAlign="Middle" Font-Size="Small">
                                  <Columns>
                                            
                          
                                     <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                       <HeaderTemplate> # </HeaderTemplate>
                                        <ItemTemplate>
       
                                            <asp:Label ID="lbl_no" runat="server" Text="<%# Container.DataItemIndex + 1 %>  "></asp:Label>
                                         </ItemTemplate>
                                    </asp:TemplateField>
                                        
                                               <asp:BoundField DataField="Name" HeaderText="Name"  />
                                                <asp:BoundField DataField="Email" HeaderText="Email"   />
                                      <asp:BoundField DataField="Message" HeaderText="Message"    ItemStyle-HorizontalAlign="Left" />
                                                <asp:BoundField DataField="DateSubmitted" DataFormatString="{0:MMM d, yyyy hh tt}"  HeaderText="Date Message" ItemStyle-HorizontalAlign="Left" />
                                        
                                        

                                   <asp:TemplateField>
                                        <HeaderTemplate> Action </HeaderTemplate>
                                     <ItemTemplate>
                                      <asp:HiddenField ID="hd_id" Value='<%#Eval("ID") %>' runat="server"></asp:HiddenField>
                        
                                      <asp:HiddenField ID="hd_name" Value='<%#Eval("Name") %>' runat="server"></asp:HiddenField>
                                     
                                      <asp:LinkButton ID="btn_delete" CssClass="btn btn-danger btn-xs " onclick="btn_delete_Click" runat="server"
                                      OnClientClick="return getConfirmation_verify();"
                                       >Remove</asp:LinkButton>
                                     </ItemTemplate>
                                   </asp:TemplateField>
                                 </Columns>
                               </asp:GridView>
                                         <asp:Label ID="lbl_item" runat="server" Text="" CssClass="form-control-label"></asp:Label>
                             </div>
                    </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <!-- Modal Container -->


<script type="text/javascript">
    function getConfirmation_verify() {
        return confirm("Are you sure you want to delete?");
    }
   
</script>
</asp:Content>

