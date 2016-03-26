-- Created by Trixter, named by Q2F2, inspired by Braxen's design

local matBlurScreen = Material( "pp/blurscreen" )

local titleBg = Color( 49, 27, 146, 120 )

local panelBg = Color( 69, 39, 160, 100 )

local btnClr = Color( 220, 220, 220, 255 )
local btnBg = Color( 81, 45, 168, 140 )
local btnDisabled = Color( 0, 0, 0, 40 )
local btnHovered = Color( 255, 255, 255, 4 )

local collapClr = Color( 81, 45, 168, 255 )
local collapBg = Color( 103, 58, 183, 70 )

local entryClr = Color( 81, 45, 168, 100 )
local entryTextClr = Color( 255, 255, 255 )
local entrySelectionClr = Color( 126, 87, 194, 70 )
local entryCursorClr = Color( 255, 255, 255 )

local sheetClr = Color( 81, 45, 168, 100 )

local QFrame = {}

surface.CreateFont( "QFrameTitle", {
	font = "Roboto Condensed",
	size = 16,
	weight = 400,
	blursize = 0,
	scanlines = 0,
	antialias = true
} )

function QFrame:Init()

    self.m_fCreateTime = SysTime()

    self.lblTitle:SetFont("QFrameTitle")

    self.btnClose.lerp = 4
	self.btnClose.Paint = function( panel, w, h )

		panel.lerp = Lerp( FrameTime() * 10, panel.lerp, panel.Hovered and 21 or 4)
		surface.SetDrawColor( panel.Hovered and Color(210,100,100,100) or Color(180,100,100,80) )
		surface.DrawRect(1, 0, w-1, panel.lerp)

		local posx, posy = self.btnClose:LocalToScreen(0, 0)
		render.SetScissorRect(posx, posy, posx+w, posy+panel.lerp, true)
		draw.SimpleText( "r", "Marlett", w / 2, 10, panel.Hovered and color_white or color_gray, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		render.SetScissorRect( 0, 0, 0, 0, false )

	end

    self.btnMaxim:Remove()
    self.btnMinim:Remove()

    self.TitleBarHeight = 24
    self.IconSize = 16

    self:DockPadding( 5, self.TitleBarHeight + 5, 5, 5 )

    timer.Simple( 0, function()
        if self.ExtraInit then
            self:ExtraInit()
        end
    end )

end

function QFrame:Paint( w, h )

    if self.m_bBackgroundBlur then
        Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
    end

    local x, y = self:GetPos()

	surface.SetMaterial( matBlurScreen )
	surface.SetDrawColor( 255, 255, 255, 255 )

	for i = 1, 3 do
		matBlurScreen:SetFloat( "$blur", i )
		matBlurScreen:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end

	surface.SetDrawColor( Color(0, 0, 0, 240 ) )
	surface.DrawRect( 0, 0, w, h )

    surface.SetDrawColor( titleBg )
    surface.DrawRect( 0, 0, w, self.TitleBarHeight )

end

function QFrame:PerformLayout()

	local titlePush = 0

	if ( IsValid( self.imgIcon ) ) then

		self.imgIcon:SetPos( self.TitleBarHeight - (self.IconSize * 1.25), self.TitleBarHeight - (self.IconSize * 1.25) )
		self.imgIcon:SetSize( self.IconSize, self.IconSize )
		titlePush = self.IconSize + ( self.IconSize / 10 )

	end

	self.btnClose:SetPos( self:GetWide() - 31 - 4 + 1, 0 )
	self.btnClose:SetSize( 31, self.TitleBarHeight )

	self.lblTitle:SetPos( 8 + titlePush, 14 / self.TitleBarHeight )
	self.lblTitle:SetSize( self:GetWide() - 25 - titlePush, self.TitleBarHeight )

    timer.Simple( 0, function()
        if self.ExtraPerformLayout then
            self:ExtraPerformLayout()
        end
    end )

end

vgui.Register( "QFrame", QFrame, "DFrame" )


local QPanel = {}

function QPanel:Init()

    timer.Simple( 0, function()
        if self.ExtraInit then
            self:ExtraInit()
        end
    end )

end

function QPanel:Paint( w, h )

    surface.SetDrawColor( self.BGColor or panelBg )
    surface.DrawRect( 0, 0, w, h )

end

function QPanel:PerformLayout()

    timer.Simple( 0, function()
        if self.ExtraPerformLayout then
            self:ExtraPerformLayout()
        end
    end )

end

vgui.Register( "QPanel", QPanel, "DPanel" )


--[[local QLabel = {} -- Nothing to make cool for it, maybe font only xd

function QLabel:Paint()

end

vgui.Register( "QLabel", QLabel, "DLabel" )]]


local QButton = {}

function QButton:Init()

    self:SetColor( btnClr )
    self:SetTall( 22 )
    self.BGColor = btnBg

    timer.Simple( 0, function()
        if self.ExtraInit then
            self:ExtraInit()
        end
    end )

end

function QButton:Paint( w, h )

    if self.m_bDisabled then

        surface.SetDrawColor( self.BGColor )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( btnDisabled )
        surface.DrawRect( 0, 0, w, h )

        self:SetCursor( "pointer" )

    else

        surface.SetDrawColor( self.BGColor )
        surface.DrawRect( 0, 0, w, h )

        if self.Hovered then
            surface.SetDrawColor( btnHovered )
            surface.DrawRect( 0, 0, w, h )
        end

    end

    return false

end

function QButton:PlaySound()

    surface.PlaySound("buttons/button9.wav")

end

function QButton:PerformLayout()

    timer.Simple( 0, function()
        if self.ExtraPerformLayout then
            self:ExtraPerformLayout()
        end
    end )

end

vgui.Register( "QButton", QButton, "DButton" )


local QCollapsibleCategory = {}

function QCollapsibleCategory:Init()

    self.BGColor = collapBg
    self.Tall = 24

    timer.Simple( 0, function()
        if self.ExtraInit then
            self:ExtraInit()
        end
    end )

end

function QCollapsibleCategory:Paint( w, h )

    surface.SetDrawColor( collapClr )
    surface.DrawRect( 0, 0, w, 24 )

    surface.SetDrawColor( collapBg )
    surface.DrawRect( 0, 24, w, h - 24 )

end

function QCollapsibleCategory:PerformLayout()
	
	DCollapsibleCategory.PerformLayout(self)

    timer.Simple( 0, function()
        if self.ExtraPerformLayout then
            self:ExtraPerformLayout()
        end
    end )

end

vgui.Register( "QCollapsibleCategory", QCollapsibleCategory, "DCollapsibleCategory" )


local QTextEntry = {}

function QTextEntry:Init()

    timer.Simple( 0, function()
        if self.ExtraInit then
            self:ExtraInit()
        end
    end )

end

function QTextEntry:Paint( w, h )

    surface.SetDrawColor( entryClr )
    surface.DrawRect( 0, 0, w, h )

    self:DrawTextEntryText( entryTextClr, entrySelectionClr, entryCursorClr )

end

function QTextEntry:PerformLayout()

    timer.Simple( 0, function()
        if self.ExtraPerformLayout then
            self:ExtraPerformLayout()
        end
    end )

end

vgui.Register( "QTextEntry", QTextEntry, "DTextEntry" )


local QPropertySheet = {}

function QPropertySheet:Init()

    timer.Simple( 0, function()
        if self.ExtraInit then
            self:ExtraInit()
        end
    end )

end

function QPropertySheet:Paint( w, h )

    surface.SetDrawColor( panelBg )
    surface.DrawRect( 0, 0, w, h )

end

function QPropertySheet:AddSheet( label, panel, material, NoStretchX, NoStretchY, Tooltip )

    if ( !IsValid( panel ) ) then return end

	local Sheet = {}

	Sheet.Name = label;

	Sheet.Tab = vgui.Create( "DTab", self )
	Sheet.Tab:SetTooltip( Tooltip )
	Sheet.Tab:Setup( label, self, panel, material )

	Sheet.Panel = panel
	Sheet.Panel.NoStretchX = NoStretchX
	Sheet.Panel.NoStretchY = NoStretchY
	Sheet.Panel:SetPos( self:GetPadding(), 20 + self:GetPadding() )
	Sheet.Panel:SetVisible( false )

    Sheet.Tab.Paint = function()

        surface.SetDrawColor( sheetClr )
        surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )

    end

    Sheet.Panel.Paint = function()

        surface.SetDrawColor( panelBg )
        surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )

    end

	panel:SetParent( self )

	table.insert( self.Items, Sheet )

	if ( !self:GetActiveTab() ) then
		self:SetActiveTab( Sheet.Tab )
		Sheet.Panel:SetVisible( true )
	end

	self.tabScroller:AddPanel( Sheet.Tab )

	return Sheet;

end

function QPropertySheet:PerformLayout()

    timer.Simple( 0, function()
        if self.ExtraPerformLayout then
            self:ExtraPerformLayout()
        end
    end )

end

vgui.Register( "QPropertySheet", QPropertySheet, "DPropertySheet" )


--[[local SKIN = {} -- Do i even need this

derma.DefineSkin( "QSkin", "QSkin for stuff", SKIN )]]


--[[local QFrame = vgui.Create( "QFrame" )  -- SIMPLE EXAMPLE, WITHOUT DPROPERTYSHEET

if not IsValid(QFrame) then
	chat.AddText( Color(255,0,0), "No QFrame." )
	return
end

QFrame:SetSize( 900, 600 )
QFrame:Center()
QFrame:SetTitle( "Dermaaa <3" )
QFrame:SetVisible(true)
QFrame:SetDraggable(true)
QFrame:ShowCloseButton(true)
QFrame:MakePopup()
QFrame:ParentToHUD()
QFrame:SetScreenLock(true)

local QPanel = vgui.Create( "QPanel", QFrame )
QPanel:SetWide( 300 )
QPanel:Dock( LEFT )

local QLabel = vgui.Create( "DLabel", QPanel )
QLabel:SetText( "Hello gamer\nYou're good.\nKeep up with the good work.\nWe believe in you.\nYou're our hope.\nNever forget this." )
QLabel:SizeToContents()
QLabel:Dock( TOP )
QLabel:DockMargin( 5, 5, 5, 5 )

local QButton = vgui.Create( "QButton", QPanel )
QButton:SetText( "Press this, this is not a trap anymore, i swear." )
QButton:Dock( TOP )
QButton:DockMargin( 5, 5, 5, 5 )
QButton:SetTall( 100 )
function QButton:DoClick()
    self:PlaySound()
end

local QCollapsibleCategory = vgui.Create( "QCollapsibleCategory", QPanel )
QCollapsibleCategory:Dock( TOP )
QCollapsibleCategory:DockMargin( 5, 5, 5, 5 )
QCollapsibleCategory:SetLabel( "self == gay" )

local QCollapsibleCategoryItem = vgui.Create( "DLabel", QCollapsibleCategory )
QCollapsibleCategoryItem:SetText( "THIS IS SO GAY" )
QCollapsibleCategoryItem:SizeToContents()
QCollapsibleCategoryItem:Dock( TOP )
QCollapsibleCategoryItem:DockMargin( 5, 10, 5, 5 )

local QTextEntry = vgui.Create( "QTextEntry", QPanel )
QTextEntry:Dock( TOP )
QTextEntry:DockMargin( 5, 5, 5, 5 )
QTextEntry:SetText( "Sexyyy" )]]


--[[local QFrame = vgui.Create( "QFrame" )

if not IsValid(QFrame) then
	chat.AddText( Color(255,0,0), "No QFrame." )
	return
end

QFrame:SetSize( 900, 600 )
QFrame:Center()
QFrame:SetTitle( "Dermaaa <3" )
QFrame:SetVisible(true)
QFrame:SetDraggable(true)
QFrame:ShowCloseButton(true)
QFrame:MakePopup()
QFrame:ParentToHUD()
QFrame:SetScreenLock(true)

local QPropertySheet = vgui.Create( "QPropertySheet", QFrame )
QPropertySheet:Dock( FILL )

local QPanel = vgui.Create( "QPanel", QFrame )
QPanel:Dock( FILL )
QPropertySheet:AddSheet( "Gay", QPanel, "icon16/cross.png" )

local QPanel2 = vgui.Create( "QPanel", QFrame )
QPanel2:Dock( FILL )
QPropertySheet:AddSheet( "Ew", QPanel2, "icon16/cross.png" )]]
