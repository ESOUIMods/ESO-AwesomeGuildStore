local gettext = LibStub("LibGetText")("AwesomeGuildStore").gettext
local FilterBase = AwesomeGuildStore.FilterBase

local SellerFilter = FilterBase:Subclass()
AwesomeGuildStore.SellerFilter = SellerFilter

local SELLER_FILTER_DATA_TYPE = 1
local SELLER_FILTER_TYPE_ID = 104
local MARGIN = 22

function SellerFilter:New(name, tradingHouseWrapper, ...)
	return FilterBase.New(self, SELLER_FILTER_TYPE_ID, name, tradingHouseWrapper, ...)
end

function SellerFilter:Initialize(name, tradingHouseWrapper)
	self:InitializeControls(name)
	self:InitializeHandlers(tradingHouseWrapper)
end

function SellerFilter:InitializeControls(name)
	local container = self.container

	local label = container:CreateControl(name .. "Label", CT_LABEL)
	label:SetFont("ZoFontWinH4")
    -- TRANSLATORS: title of the text filter in the left panel on the search tab
	label:SetText(gettext("Seller @-name:"))
	self:SetLabelControl(label)

	local input = CreateControlFromVirtual(name .. "Input", container, "AwesomeGuildStoreNameFilterTemplate")
	input:ClearAnchors()
	input:SetAnchor(BOTTOMLEFT, container, BOTTOMLEFT, 0, 0)
	input:SetAnchor(BOTTOMRIGHT, container, BOTTOMRIGHT, 0, 0)
	local inputBox = input:GetNamedChild("Box")
    -- TRANSLATORS: placeholder text for the text filter input box
	ZO_EditDefaultText_Initialize(inputBox, gettext("Filter by @-name"))
	inputBox:SetMaxInputChars(250)
	self.inputBox = inputBox

	container:SetHeight(22 + 4 + 28)

	local tooltipText = gettext("Reset <<1>> Filter", label:GetText():gsub(":", ""))
	self.resetButton:SetTooltipText(tooltipText)
end

function SellerFilter:InitializeHandlers(tradingHouseWrapper)
	local tradingHouse = tradingHouseWrapper.tradingHouse
	local inputBox = self.inputBox
	inputBox:SetHandler("OnTextChanged", function(control)
		ZO_EditDefaultText_OnTextChanged(inputBox)
		self:HandleChange()
	end)
	self.LTF = LibStub("LibTextFilter")
end

function SellerFilter:BeforeRebuildSearchResultsPage(tradingHouseWrapper)
	local searchTerm = self.inputBox:GetText()
	if(searchTerm ~= "") then
		self.searchTerm = searchTerm:lower()
		return true
	end
	return false
end

function SellerFilter:FilterPageResult(index, icon, name, quality, stackCount, sellerName, timeRemaining, purchasePrice)
	local LTF = self.LTF
	local isMatch, result = LTF:Filter(sellerName:lower(), self.searchTerm)
-- d("FPR want:"..tostring(self.searchTerm).."  sellerName:"..tostring(sellerName
-- 	.."  isMatch:"..tostring(isMatch)))
	return isMatch
end

function SellerFilter:Reset()
	self.inputBox:SetText("")
end

function SellerFilter:IsDefault()
	local inputBox = self.inputBox
	return (inputBox:GetText() == "")
end

function SellerFilter:Serialize()
	return self.inputBox:GetText()
end

function SellerFilter:Deserialize(searchterm)
	if(not searchterm) then searchterm = "" end
	self.inputBox:SetText(searchterm)
end

function SellerFilter:GetTooltipText(state)
	if(state and state ~= "") then
		return {{label = gettext("Seller @-name:"):sub(0, -2), text = state}}
	end
	return {}
end
