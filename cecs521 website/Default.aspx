<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="cecs521_website._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1>TRUKER</h1>
        <p class="lead">A website that helps you look up other truck drivers near you. You can also request pickups from the truckdrivers too.</p>  
    </div>

    <div class="row">
        <div class="col-md-4">
            <h2>Getting started</h2>
            <p>
                Arrange a pickup now!</p>
            <p>
                <a class="btn btn-default" href="Maps.aspx">Maps &raquo;</a>
            </p>
        </div>
    </div>

</asp:Content>
