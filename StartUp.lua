local ADDON_NAME = "AwesomeGuildStore"

AwesomeGuildStore = ZO_CallbackObject:New()

local nextEventHandleIndex = 1

local function RegisterForEvent(event, callback)
    local eventHandleName = ADDON_NAME .. nextEventHandleIndex
    EVENT_MANAGER:RegisterForEvent(eventHandleName, event, callback)
    nextEventHandleIndex = nextEventHandleIndex + 1
    return eventHandleName
end

local function UnregisterForEvent(event, name)
    EVENT_MANAGER:UnregisterForEvent(name, event)
end

local function WrapFunction(object, functionName, wrapper)
    if(type(object) == "string") then
        wrapper = functionName
        functionName = object
        object = _G
    end
    local originalFunction = object[functionName]
    object[functionName] = function(...) return wrapper(originalFunction, ...) end
end

local function OnAddonLoaded(callback)
    local eventHandle = ""
    eventHandle = RegisterForEvent(EVENT_ADD_ON_LOADED, function(event, name)
        if(name ~= ADDON_NAME) then return end
        callback()
        UnregisterForEvent(event, name)
    end)
end

AwesomeGuildStore.UnregisterForEvent = UnregisterForEvent
AwesomeGuildStore.RegisterForEvent = RegisterForEvent
AwesomeGuildStore.WrapFunction = WrapFunction
-----------------------------------------------------------------------------------------

AwesomeGuildStore.GetAPIVersion = function() return 3 end

-- convenience functions for using the callback object:
function AwesomeGuildStore:RegisterBeforeInitialSetupCallback(...)
    self:RegisterCallback("BeforeInitialSetup", ...)
end
function AwesomeGuildStore:FireBeforeInitialSetupCallbacks(...)
    self:FireCallbacks("BeforeInitialSetup", ...)
end

function AwesomeGuildStore:RegisterAfterInitialSetupCallback(...)
    self:RegisterCallback("AfterInitialSetup", ...)
end
function AwesomeGuildStore:FireAfterInitialSetupCallbacks(...)
    self:FireCallbacks("AfterInitialSetup", ...)
end

function AwesomeGuildStore:RegisterOnOpenSearchTabCallback(...)
    self:RegisterCallback("OnOpenSearchTab", ...)
end
function AwesomeGuildStore:FireOnOpenSearchTabCallbacks(...)
    self:FireCallbacks("OnOpenSearchTab", ...)
end

function AwesomeGuildStore:RegisterOnCloseSearchTabCallback(...)
    self:RegisterCallback("OnCloseSearchTab", ...)
end
function AwesomeGuildStore:FireOnCloseSearchTabCallbacks(...)
    self:FireCallbacks("OnCloseSearchTab", ...)
end

function AwesomeGuildStore:RegisterOnInitializeFiltersCallback(...)
    self:RegisterCallback("OnInitializeFilters", ...)
end
function AwesomeGuildStore:FireOnInitializeFiltersCallbacks(...)
    self:FireCallbacks("OnInitializeFilters", ...)
end

-- deprecated callback names for CALLBACK_MANAGER:
AwesomeGuildStore.BeforeInitialSetupCallbackName = ADDON_NAME .. "_BeforeInitialSetup"
AwesomeGuildStore.AfterInitialSetupCallbackName = ADDON_NAME .. "_AfterInitialSetup"
AwesomeGuildStore.OnOpenSearchTabCallbackName = ADDON_NAME .. "_OnOpenSearchTab"
AwesomeGuildStore.OnCloseSearchTabCallbackName = ADDON_NAME .. "_OnCloseSearchTab"
AwesomeGuildStore.OnInitializeFiltersCallbackName = ADDON_NAME .. "_OnInitializeFilters"

-- compatibility layer for old callback handling:
AwesomeGuildStore:RegisterBeforeInitialSetupCallback(function(...) CALLBACK_MANAGER:FireCallbacks(AwesomeGuildStore.BeforeInitialSetupCallbackName, ...) end)
AwesomeGuildStore:RegisterAfterInitialSetupCallback(function(...) CALLBACK_MANAGER:FireCallbacks(AwesomeGuildStore.AfterInitialSetupCallbackName, ...) end)
AwesomeGuildStore:RegisterOnOpenSearchTabCallback(function(...) CALLBACK_MANAGER:FireCallbacks(AwesomeGuildStore.OnOpenSearchTabCallbackName, ...) end)
AwesomeGuildStore:RegisterOnCloseSearchTabCallback(function(...) CALLBACK_MANAGER:FireCallbacks(AwesomeGuildStore.OnCloseSearchTabCallbackName, ...) end)
AwesomeGuildStore:RegisterOnInitializeFiltersCallback(function(...) CALLBACK_MANAGER:FireCallbacks(AwesomeGuildStore.OnInitializeFiltersCallbackName, ...) end)

do
    local LONG_PREFIX = "AwesomeGuildStore"
    local SHORT_PREFIX = "AGS"

    local prefix = LONG_PREFIX
    local function SetMessagePrefix(isShort)
        prefix = isShort and SHORT_PREFIX or LONG_PREFIX
    end

    local function Print(message, ...)
        if(select("#", ...) > 0) then
            message = message:format(...)
        end
        df("[%s] %s", prefix, message)
    end

    AwesomeGuildStore.Print = Print
    AwesomeGuildStore.SetMessagePrefix = SetMessagePrefix
end

local function IsSameAction(actionName, layerIndex, categoryIndex, actionIndex)
    local targetTayerIndex, targetCategoryIndex, targetActionIndex = GetActionIndicesFromName(actionName)
    return not (layerIndex ~= targetTayerIndex or categoryIndex ~= targetCategoryIndex or actionIndex ~= targetActionIndex)
end

local function IntegrityCheck()
    assert(LibStub)
    assert(LibStub("LibAddonMenu-2.0", true))
    assert(LAMCreateControl.panel)
    assert(LAMCreateControl.submenu)
    assert(LAMCreateControl.button)
    assert(LAMCreateControl.checkbox)
    assert(LAMCreateControl.colorpicker)
    assert(LAMCreateControl.custom)
    assert(LAMCreateControl.description)
    assert(LAMCreateControl.dropdown)
    assert(LAMCreateControl.editbox)
    assert(LAMCreateControl.header)
    assert(LAMCreateControl.slider)
    assert(LAMCreateControl.iconpicker)
    assert(LAMCreateControl.divider)
    assert(LibStub("LibFilters-2.0", true))
    assert(LibStub("libCommonInventoryFilters", true))
    assert(LibStub("LibTextFilter", true))
    assert(LibStub("LibCustomMenu", true))
    assert(LibStub("LibMapPing", true))
    assert(LibStub("LibGPS2", true))
    assert(LibStub("LibDateTime", true))
    assert(LibStub("LibPromises", true))
    assert(LibStub("LibGetText", true))
    assert(AwesomeGuildStore.LoadSettings)
    assert(AwesomeGuildStore.IsUnitGuildKiosk)
    assert(AwesomeGuildStore.MinMaxRangeSlider)
    assert(AwesomeGuildStore.ButtonGroup)
    assert(AwesomeGuildStore.ToggleButton)
    assert(AwesomeGuildStore.SimpleIconButton)
    assert(AwesomeGuildStore.LoadingIcon)
    assert(AwesomeGuildStore.FilterBase)
    assert(AwesomeGuildStore.FILTER_PRESETS)
    assert(AwesomeGuildStore.CategorySubfilter)
    assert(AwesomeGuildStore.KnownRecipeFilter)
    assert(AwesomeGuildStore.KnownMotifFilter)
    assert(AwesomeGuildStore.KnownRuneTranslationFilter)
    assert(AwesomeGuildStore.ResearchableTraitsFilter)
    assert(AwesomeGuildStore.ItemStyleFilter)
    assert(AwesomeGuildStore.ItemSetFilter)
    assert(AwesomeGuildStore.CraftedItemFilter)
    assert(AwesomeGuildStore.CategorySelector)
    assert(AwesomeGuildStore.PriceFilter)
    assert(AwesomeGuildStore.LevelFilter)
    assert(AwesomeGuildStore.QualityFilter)
    assert(AwesomeGuildStore.TextFilter)
    assert(AwesomeGuildStore.UnitPriceFilter)
    assert(AwesomeGuildStore.RecipeImprovementFilter)
    assert(AwesomeGuildStore.SavedSearchTooltip)
    assert(AwesomeGuildStore.SearchLibrary)
    assert(AwesomeGuildStoreSearchLibrary)
    assert(AwesomeGuildStore.InitializeAugmentedMails)
    assert(AwesomeGuildStore.HiredTraderTooltip)
    assert(AwesomeGuildStore.GuildSelector)
    assert(AwesomeGuildStore.Paging)
    assert(AwesomeGuildStore.ActivityBase)
    assert(AwesomeGuildStore.CancelSaleOperation)
    assert(AwesomeGuildStore.RequestListingsOperation)
    assert(AwesomeGuildStore.ExecuteSearchOperation)
    assert(AwesomeGuildStore.SwitchGuildOperation)
    assert(AwesomeGuildStore.ActivityManager)
    assert(AwesomeGuildStore.TradingHouseWrapper)
    assert(AwesomeGuildStore.SearchTabWrapper)
    assert(AwesomeGuildStore.SellTabWrapper)
    assert(AwesomeGuildStore.ListingTabWrapper)
    assert(AwesomeGuildStore.KeybindStripWrapper)
    assert(AwesomeGuildStore.ActivityLogWrapper)
    assert(AwesomeGuildStore.KioskData)
    assert(AwesomeGuildStore.StoreData)
    assert(AwesomeGuildStore.KioskList)
    assert(AwesomeGuildStore.StoreList)
    assert(AwesomeGuildStore.OwnerList)
    assert(AwesomeGuildStoreGuildTraders)
    assert(AwesomeGuildStoreGuilds)
    assert(AwesomeGuildStore.TraderListControl)
    assert(AwesomeGuildStore.GuildListControl)
    assert(AwesomeGuildStore.OwnerHistoryControl)
    assert(AwesomeGuildStore.KioskHistoryControl)
    assert(AwesomeGuildStore.InitializeGuildList)
    assert(AwesomeGuildStore.InitializeGuildStoreList)
    assert(AwesomeGuildStore.SalesCategorySelector)
end

do
    -- workaround for insecure code errors due to the ZO_ItemSlotActionsController being lazily instantiated
    HUD_SCENE:AddFragment(INVENTORY_FRAGMENT)
    HUD_UI_SCENE:AddFragment(INVENTORY_FRAGMENT)

    local original = ZO_CharacterWindowStats_HideComparisonValues
    ZO_CharacterWindowStats_HideComparisonValues = ZO_InventorySlot_RemoveMouseOverKeybinds -- force the controller to be instantiated
    ZO_PreHook("ZO_CharacterWindowStats_HideComparisonValues", function()
        ZO_CharacterWindowStats_HideComparisonValues = original
    end)

    -- and clean up afterwards
    local function OnStateChange(oldState, newState)
        if newState == SCENE_SHOWN then
            INVENTORY_FRAGMENT.control:SetHidden(true) -- make sure it doesn't show up
            HUD_UI_SCENE:RemoveFragment(INVENTORY_FRAGMENT)
            HUD_SCENE:RemoveFragment(INVENTORY_FRAGMENT)
            HUD_UI_SCENE:UnregisterCallback("StateChange", OnStateChange)
            HUD_SCENE:UnregisterCallback("StateChange", OnStateChange)
        end
    end
    HUD_UI_SCENE:RegisterCallback("StateChange", OnStateChange)
    HUD_SCENE:RegisterCallback("StateChange", OnStateChange)
end

OnAddonLoaded(function()
    IntegrityCheck()

    local saveData = AwesomeGuildStore.LoadSettings()
    AwesomeGuildStore.SetMessagePrefix(saveData.shortMessagePrefix)
    if(saveData.guildTraderListEnabled) then
        AwesomeGuildStore.InitializeGuildStoreList(saveData)
    end
    AwesomeGuildStore.main = AwesomeGuildStore.TradingHouseWrapper:New(saveData)
    AwesomeGuildStore.InitializeAugmentedMails(saveData)

    local gettext = LibStub("LibGetText")("AwesomeGuildStore").gettext

    local actionName, defaultKey = "AGS_SUPPRESS_LOCAL_FILTERS", KEY_CTRL
    -- TRANSLATORS: keybind label in the controls menu
    ZO_CreateStringId("SI_BINDING_NAME_AGS_SUPPRESS_LOCAL_FILTERS", gettext("Suppress Local Filters"))

    local function HandleKeyBindReset()
        saveData.hasTouchedAction = {}
    end

    ZO_PreHook("ResetAllBindsToDefault", HandleKeyBindReset)
    ZO_PreHook("ResetKeyboardBindsToDefault", HandleKeyBindReset)

    local function HandleKeyBindTouched(_, layerIndex, categoryIndex, actionIndex, bindingIndex)
        if(IsSameAction(actionName, layerIndex, categoryIndex, actionIndex) and bindingIndex == 1) then
            saveData.hasTouchedAction[actionName] = true
        end
    end

    RegisterForEvent(EVENT_KEYBINDING_CLEARED, HandleKeyBindTouched)
    RegisterForEvent(EVENT_KEYBINDING_SET, HandleKeyBindTouched)

    if(not saveData.hasTouchedAction["AGS_SUPPRESS_LOCAL_FILTERS"]) then
        CreateDefaultActionBind(actionName, defaultKey)
    end
end)
