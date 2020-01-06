UrzTrashCan = CreateFrame("Frame", "UrzTrashCan", UIParent);
UrzTrashCan:Hide();

local EventWatcher = CreateFrame("Frame");

-- Needs to be loaded before variables load
for i = 1, NUM_CHAT_WINDOWS do
    _G["ChatFrame"..i]:SetClampRectInsets(-35, 35, 35, -35);
end
hooksecurefunc(ExpBarMixin, "Update", ExpBarMixin.UpdateCurrentText);
--ReputationBar seems to function properly already
--hooksecurefunc(AzeriteBarMixin, "Update", AzeriteBarMixin.UpdateOverlayFrameText); --Causes error
hooksecurefunc(ArtifactBarMixin, "Update", ArtifactBarMixin.UpdateOverlayFrameText);
hooksecurefunc(HonorBarMixin, "Update", HonorBarMixin.UpdateOverlayFrameText);
--hooksecurefunc(UIWidgetTopCenterContainerMixin, "OnLoad", function() UIWidgetTopCenterContainerFrame:EnableMouse(false); end);

function Remove(name)
    if ( name ) then
        name:SetParent(UrzTrashCan);
    end
end

function Move(name, p1, parent, p2, x, y)
    if ( name ) then
        name:ClearAllPoints();
        name:SetPoint(p1, parent, p2, x, y);
    end
end

local function SetNameplates()
    if ( not UrzVariables[1] ) then
        return
    end
    SetCVar("nameplateMaxDistance", 40); -- Default 60
    SetCVar("nameplateMinAlpha", 1); -- Default 0.5
    SetCVar("nameplateMinScale", 1); -- Default 0.8
    --SetCVar("nameplateOtherTopInset", 0.08); -- Default 0.08
    --SetCVar("nameplateOtherBottomInset", 0.1); -- Default 0.1
    hooksecurefunc("CompactUnitFrame_OnLoad", function(self)
            self:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
            if ( self.BuffFrame ) then
                self.name:SetFont("Fonts\\ARIALN.TTF", 12);
                self.name:SetShadowOffset(1, -1);
            end
    end);
    hooksecurefunc(NameplateBuffContainerMixin, "UpdateAnchor", function(self)
            self:SetPoint("BOTTOM", self:GetParent().name, "TOP", 0, 0);
    end);
    hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
            frame.name:SetText(GetUnitName(frame.unit, true));
            frame.name:Show();
    end);
    local function setup(frame)
        local isTanking = UnitDetailedThreatSituation("player", frame.displayedUnit);
        if ( not isTanking ) then
            frame.name:SetVertexColor(1, 1, 1, 1);
        else
            frame.name:SetVertexColor(1, 0, 0, 1);
        end
    end
    hooksecurefunc("CompactUnitFrame_UpdateName", setup);
    hooksecurefunc("CompactUnitFrame_UpdateAggroHighlight", setup);
    hooksecurefunc("CompactUnitFrame_UpdateHealthBorder", function(frame)
            if ( frame.optionTable.selectedBorderColor ) then
                if ( UnitIsUnit(frame.displayedUnit, "target") ) then
                    frame.healthBar.border:SetVertexColor(1, 1, 1, 1);
                elseif ( UnitIsUnit(frame.displayedUnit, "mouseover") ) then
                    frame.healthBar.border:SetVertexColor(1, 1, 0, 1);
                    frame:SetScript("OnUpdate", function(self, elapsed)
                            if ( self.optionTable.selectedBorderColor ) then
                                if ( UnitIsUnit(self.displayedUnit, "target") ) then
                                    self:SetScript("OnUpdate", nil);
                                    self.healthBar.border:SetVertexColor(1, 1, 1, 1);
                                elseif ( not UnitIsUnit(self.displayedUnit, "mouseover") ) then
                                    self:SetScript("OnUpdate", nil);
                                    self.healthBar.border:SetVertexColor(0, 0, 0, 0);
                                end
                            end
                    end);
                else
                    frame.healthBar.border:SetVertexColor(0, 0, 0, 0);
                end
            end
    end);
    hooksecurefunc("CompactUnitFrame_OnEvent", function(self, event, ...)
            if ( event == "UPDATE_MOUSEOVER_UNIT" ) then
                CompactUnitFrame_UpdateHealthBorder(self);
            end
    end);
end

local function SetMainMenu()
    if ( not UrzVariables[13] ) then
        return
    end
    for _, name in pairs({MainMenuBarArtFrame.LeftEndCap, MainMenuBarArtFrame.RightEndCap, MainMenuBarArtFrameBackground, MainMenuBarArtFrame.PageNumber, ActionBarUpButton, ActionBarDownButton, MicroButtonAndBagsBar.MicroBagBar, SlidingActionBarTexture0, SlidingActionBarTexture1, PossessBackground1, PossessBackground2, StatusTrackingBarManager.SingleBarLarge, StatusTrackingBarManager.SingleBarLargeUpper, StatusTrackingBarManager.SingleBarSmall, StatusTrackingBarManager.SingleBarSmallUpper}) do
        Remove(name);
    end
    for _, name in pairs({MainMenuBar, MainMenuBarArtFrame, MicroButtonAndBagsBar, PossessBarFrame, StanceBarFrame, MultiCastActionBarFrame, PetActionBarFrame, MultiBarLeft, MultiBarRight, MultiBarBottomLeft, MultiBarBottomRight, StatusTrackingBarManager}) do
        name:SetFrameStrata("MEDIUM");
        name:EnableMouse(false);
    end
    for _, text in pairs({"ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarLeftButton", "MultiBarRightButton", "PossessButton", "StanceButton", "MultiCastActionButton", "PetActionButton"}) do
        for i = 1, 12 do
            local name = _G[text..i];
            if ( name ) then
                name:SetScale(1);
                name:SetSize(36, 36);
                name:GetNormalTexture():SetPoint("TOPLEFT", name, "TOPLEFT", -12, 12);
                name:GetNormalTexture():SetPoint("BOTTOMRIGHT", name, "BOTTOMRIGHT", 13, -13);
                Remove(_G[text..i.."FloatingBG"]);
                Remove(_G[text..i.."Name"]);
            end
        end
    end
    for _, name in pairs({MainMenuBarVehicleLeaveButton, PossessBarFrame, StanceBarFrame, MultiCastActionBarFrame, PetActionBarFrame}) do
        name:SetScale(0.7);
    end
    MainMenuBarVehicleLeaveButton:SetSize(36, 36);
    MainMenuBarBackpackButton:GetNormalTexture():SetPoint("TOPLEFT", MainMenuBarBackpackButton, "TOPLEFT", -12, 12);
    MainMenuBarBackpackButton:GetNormalTexture():SetPoint("BOTTOMRIGHT", MainMenuBarBackpackButton, "BOTTOMRIGHT", 13, -13);
    Move(MainMenuBarArtFrameBackground, "BOTTOMLEFT", UIParent, "BOTTOM", -257, 0);
    Move(MultiBarBottomLeftButton1, "BOTTOMLEFT", ActionButton1, "TOPLEFT", 0, 6);
    Move(MultiBarBottomRightButton1, "BOTTOMLEFT", MultiBarBottomLeftButton1, "TOPLEFT", 0, 6);
    local anchor = "ActionButton";
    if ( SHOW_MULTI_ACTIONBAR_1 ) then
        anchor = "MultiBarBottomRightButton";
    elseif ( SHOW_MULTI_ACTIONBAR_2 ) then
        anchor = "MultiBarBottomLeftButton";
    end
    Move(PossessButton1, "BOTTOMLEFT",  _G[anchor..1], "TOPLEFT", 0, 6);
    Move(StanceButton1, "BOTTOMLEFT",  _G[anchor..1], "TOPLEFT", 0, 6);
    Move(MultiCastActionButton1, "BOTTOMLEFT",  _G[anchor..1], "TOPLEFT", 0, 6);
    Move(PetActionButton10, "BOTTOMRIGHT",  _G[anchor..12], "TOPRIGHT", 0, 6);
    for i = 2, 12 do
        Move(_G["ActionButton"..i], "LEFT", _G["ActionButton"..i-1], "RIGHT", 6, 0);
        Move(_G["MultiBarBottomLeftButton"..i], "LEFT", _G["MultiBarBottomLeftButton"..i-1], "RIGHT", 6, 0);
        Move(_G["MultiBarBottomRightButton"..i], "LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", 6, 0);
        Move(_G["PossessButton"..i], "LEFT", _G["PossessButton"..i-1], "RIGHT", 6, 0);
        Move(_G["StanceButton"..i], "LEFT", _G["StanceButton"..i-1], "RIGHT", 6, 0);
        Move(_G["MultiCastActionButton"..i], "LEFT", _G["MultiCastActionButton"..i-1], "RIGHT", 6, 0);
        Move(_G["PetActionButton"..11-i], "RIGHT", _G["PetActionButton"..12-i], "LEFT", -6, 0);
    end
    hooksecurefunc("MainMenuBarVehicleLeaveButton_Update", function() Move(MainMenuBarVehicleLeaveButton, "BOTTOMLEFT", PossessButton1, "TOPLEFT", 0, 6) end);
    Move(MainMenuBarVehicleLeaveButton, "BOTTOMLEFT", PossessButton1, "TOPLEFT", 0, 6);
    local function setup()
        local visibleBars = {};
        for i, bar in ipairs(StatusTrackingBarManager.bars) do
            if ( bar:ShouldBeVisible() ) then
                table.insert(visibleBars, bar);
            end
        end
        table.sort(visibleBars, function(left, right) return left:GetPriority() < right:GetPriority() end);
        if ( #visibleBars < 1 ) then
            Move(MainMenuBarBackpackButton, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -6, 40);
        else
            visibleBars[1]:SetSize(285, 15);
            visibleBars[1].StatusBar:SetSize(285, 15);
            Move(visibleBars[1].OverlayFrame.Text, "CENTER", visibleBars[1].StatusBar, "CENTER", 0, 1);
            visibleBars[1].OverlayFrame:SetFrameStrata("MEDIUM");
            --Move(visibleBars[1], "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -6, 36);
            Move(visibleBars[1], "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -6, 39);
            Move(MainMenuBarBackpackButton, "BOTTOMRIGHT",  UIParent, "BOTTOMRIGHT", -6, 56);
        end
        if ( #visibleBars > 1 ) then
            visibleBars[2]:SetSize(285, 15);
            visibleBars[2].StatusBar:SetSize(285, 15);
            Move(visibleBars[2].OverlayFrame.Text, "CENTER", visibleBars[2].StatusBar, "CENTER", 0, 1);
            visibleBars[2].OverlayFrame:SetFrameStrata("MEDIUM");
            --Move(visibleBars[2], "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -6, 52);
            Move(visibleBars[2], "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -6, 55);
            Move(MainMenuBarBackpackButton, "BOTTOMRIGHT",  UIParent, "BOTTOMRIGHT", -6, 72);
        end
    end
    hooksecurefunc(StatusTrackingBarManager, "UpdateBarsShown", setup);
    StatusTrackingBarManager:UpdateBarsShown();
    ConsoleExec("xpBarText 1");
end

local function SetChatframes()
    if ( not UrzVariables[14] ) then
        return
    end
    for i = 1, NUM_CHAT_WINDOWS do
        for _, text in pairs({"ButtonFrameMinimizeButton", "ButtonFrameBackground", "ButtonFrameTopLeftTexture", "ButtonFrameBottomLeftTexture", "ButtonFrameTopRightTexture", "ButtonFrameBottomRightTexture", "ButtonFrameLeftTexture", "ButtonFrameRightTexture", "ButtonFrameBottomTexture", "ButtonFrameTopTexture"}) do
            Remove(_G["ChatFrame"..i..text]);
        end
        _G["ChatFrame"..i.."Tab"]:SetScript("OnDoubleClick", nil);
        if ( i ~= 1 ) then
            _G["ChatFrame"..i.."EditBox"]:SetAllPoints(ChatFrame1EditBox);
        end
    end
    FCFManager_RegisterDedicatedFrame(ChatFrame2, "PET_BATTLE_COMBAT_LOG");
    for name in pairs(ChatTypeGroup) do
        SetChatColorNameByClass(name, true);
    end
    for i = 1, MAX_WOW_CHAT_CHANNELS do
        local name = "CHANNEL"..i;
        if ( name ) then
            SetChatColorNameByClass(name, true);
        end
    end
    ChatFrameMenuButton:SetScript("OnClick", function(self, button, down)
            PlaySound(825);
            if ( not ChatMenu:IsShown() ) then
                ChatMenu:Show();
            else
                ChatMenu:Hide();
            end
    end);
    local function setup(editBox)
        if ( editBox ) then
            editBox:SetFrameStrata("BACKGROUND");
        end
    end
    setup(ChatFrame1EditBox);
    hooksecurefunc("ChatEdit_DeactivateChat", setup);
    hooksecurefunc("ChatEdit_SetLastActiveWindow", setup);
    hooksecurefunc("FCFDock_RemoveChatFrame", setup);
end

local function SetUnitframes()
    if ( not UrzVariables[15] ) then
        return
    end
    PlayerFrame:UnregisterEvent("UNIT_COMBAT");
    PetFrame:UnregisterEvent("UNIT_COMBAT");
    for _, name in pairs({PlayerStatusTexture, PlayerAttackBackground, PlayerFrameFlash, PlayerStatusGlow, PlayerAttackGlow, PlayerRestGlow, PlayerHitIndicator, PetFrameFlash, PetAttackModeTexture, PetHitIndicator, TargetFrameFlash, FocusFrameFlash}) do
        Remove(name);
    end
    for _, name in pairs({PlayerFrameHealthBar, PlayerFrameManaBar, PlayerPVPIconHitArea, PetFrameHealthBar, PetFrameManaBar, TargetFrameHealthBar, TargetFrameManaBar, FocusFrameHealthBar, FocusFrameManaBar}) do
        name:EnableMouse(false);
    end
    hooksecurefunc("PlayerFrame_UpdateStatus", function()
            if (( not UnitHasVehiclePlayerFrameUI("player") ) and ( UnitAffectingCombat("player") )) then
                PlayerAttackIcon:Show();
                PlayerRestIcon:Hide();
            end
            if (( PlayerAttackIcon:IsShown() ) or ( PlayerRestIcon:IsShown() )) then
                PlayerLevelText:Hide();
            else
                PlayerLevelText:Show();
            end
    end);
    hooksecurefunc("TextStatusBar_UpdateTextString", function(textStatusBar)
            if (( textStatusBar == PlayerFrameHealthBar ) or ( textStatusBar == TargetFrameHealthBar )) then
                local current = textStatusBar:GetValue();
                local _, max = textStatusBar:GetMinMaxValues();
                if (( current > 0) and ( max > 0 )) then
                    textStatusBar.TextString:SetFormattedText("%i%%   %s", ceil(current/max*100), AbbreviateLargeNumbers(current));
                end
            end
    end);
    TextStatusBar_UpdateTextString(PlayerFrameHealthBar);
    TextStatusBar_UpdateTextString(TargetFrameHealthBar);
end

local function SetMinimap()
    if ( not UrzVariables[10] ) then
        return
    end
    for _, name in pairs({TimeManagerClockButton:GetRegions(), MiniMapWorldMapButton, MinimapZoomIn, MinimapZoomOut, MiniMapTracking}) do
        Remove(name);
    end
    MinimapZoneTextButton:SetScript("OnClick", ToggleWorldMap);
    MinimapZoneText:SetWidth(120);
    Move(MinimapZoneTextButton, "LEFT", MinimapCluster, "CENTER", -70, 83);
    Move(MinimapZoneText, "LEFT", MinimapCluster, "CENTER", -70, 83);
    Move(TimeManagerClockButton, "RIGHT", MinimapCluster, "CENTER", 97, 81);
    Move(TimeManagerClockTicker, "RIGHT", MinimapCluster, "CENTER", 86, 83);
    MinimapZoneText:SetFont("Fonts\\FRIZQT__.TTF", 11);
    TimeManagerClockTicker:SetFont("Fonts\\FRIZQT__.TTF", 11);
    Minimap:EnableMouseWheel(true);
    Minimap:SetScript("OnMouseWheel", function(self, delta)
            local zoom = Minimap:GetZoom();
            if ( delta > 0 and zoom < 5 ) then
                Minimap:SetZoom(zoom+1);
            elseif ( delta < 0 and zoom > 0 ) then
                Minimap:SetZoom(zoom-1);
            end
    end);
    Minimap:SetScript("OnMouseUp", function(self, button)
            if ( button == "LeftButton" ) then
                Minimap_OnClick(self);
            elseif ( button == "RightButton" ) then
                PlaySound(856);
                ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "Minimap", -150, 130);
            end
    end);
    GarrisonLandingPageMinimapButton:SetScale(0.7);
    GarrisonLandingPageMinimapButton.LoopingGlow:SetScale(0.7);
    Move(GarrisonLandingPageMinimapButton, "TOPLEFT", MinimapBackdrop, "TOPLEFT", 57, -169);
    local function setup()
        if ( not UnitAffectingCombat("player") ) then
            if (( OrderHallCommandBar ) and ( OrderHallCommandBar:IsShown() )) then
                MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -4, -25);
            else
                MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -4, -4);
            end
        end
    end
    hooksecurefunc("OrderHall_CheckCommandBar", setup);
    OrderHall_CheckCommandBar();
end

local function HideBags()
    if ( not UrzVariables[12] ) then
        return
    end
    local function SetSideMenuAlpha(alpha)
        for _, name in pairs({MainMenuBarBackpackButton, CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot, StatusTrackingBarManager.bars[1], StatusTrackingBarManager.bars[2], StatusTrackingBarManager.bars[3], StatusTrackingBarManager.bars[4], StatusTrackingBarManager.bars[5]}) do
            name:SetAlpha(alpha);
        end
        for i = 1, #MICRO_BUTTONS do
            _G[MICRO_BUTTONS[i]]:SetAlpha(alpha);
        end
    end
    local function setup()
        if ( MainMenuBar:IsShown() ) then
            SetSideMenuAlpha(0);
        else
            SetSideMenuAlpha(1);
        end
    end
    setup();
    hooksecurefunc("MoveMicroButtons", setup);
    for _, name in pairs({MainMenuBarBackpackButton, CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot, StatusTrackingBarManager.bars[1], StatusTrackingBarManager.bars[2], StatusTrackingBarManager.bars[3], StatusTrackingBarManager.bars[4], StatusTrackingBarManager.bars[5]}) do
        name:HookScript("OnEnter", function(self, motion)
                SetSideMenuAlpha(1);
        end);
        name:HookScript("OnLeave", function(self, motion)
                SetSideMenuAlpha(0);
        end);
    end
    for i = 1, #MICRO_BUTTONS do
        local name = _G[MICRO_BUTTONS[i]];
        name:HookScript("OnEnter", function(self, motion)
                SetSideMenuAlpha(1);
        end);
        name:HookScript("OnLeave", function(self, motion)
                setup();
        end);
    end
end

local function SetAutoSell()
    local EventFrame = CreateFrame("Frame");
    EventFrame:RegisterEvent("MERCHANT_SHOW");

    local selling, bagsChecked, bagsEmpty;
    local bag, slot, link, count, price, valueInBags, totalMoney;
    local gold, silver, copper, msg;
    local messageType;

    local function SellItems()
        if ( not UrzVariables[5] ) then
            return
        end

        if ( not bagsChecked ) then
            bagsChecked = true;
            valueInBags = 0;
            for bag = 0, 4 do
                for slot = 0, GetContainerNumSlots(bag) do
                    link = GetContainerItemLink(bag, slot);
                    if (( link ) and (select(3, GetItemInfo(link)) == 0) and (select(11, GetItemInfo(link)) > 0)) then
                        count = select(2, GetContainerItemInfo(bag, slot));
                        price = select(11, GetItemInfo(link));
                        valueInBags = price * count + valueInBags;
                    end
                end
            end
        end
        bagsEmpty = true;
        for bag = 0, 4 do
            for slot = 0, GetContainerNumSlots(bag) do
                link = GetContainerItemLink(bag, slot);
                if (( link ) and (select(3, GetItemInfo(link)) == 0) and (select(11, GetItemInfo(link)) > 0)) then
                    if ( selling ) then
                        PickupContainerItem(bag, slot);
                        PickupMerchantItem();
                        bagsEmpty = false;
                    end
                end
            end
        end
        if ( not bagsEmpty ) then
            C_Timer.After(1, SellItems);
            return
        end
        totalMoney = 0;
        for bag = 0, 4 do
            for slot = 0, GetContainerNumSlots(bag) do
                link = GetContainerItemLink(bag, slot);
                if (( link ) and (select(3, GetItemInfo(link)) == 0) and (select(11, GetItemInfo(link)) > 0)) then
                    count = select(2, GetContainerItemInfo(bag, slot));
                    price = select(11, GetItemInfo(link));
                    totalMoney = price * count + totalMoney;
                end
            end
        end
        if ( valueInBags > 0 ) then
            totalMoney = valueInBags - totalMoney;
            gold = floor(abs(totalMoney / 10000));
            silver = floor(abs(mod(totalMoney / 100, 100)));
            copper = floor(abs(mod(totalMoney, 100)));
            msg = format("Received %d Gold, %d Silver, %d Copper from sold junk.", gold, silver, copper);
            DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0);
        end
    end

    EventFrame:SetScript("OnEvent", function(self, event, ...)
            if ( event == "MERCHANT_SHOW" ) then
                self:UnregisterEvent("MERCHANT_SHOW");
                self:RegisterEvent("MERCHANT_CLOSED");
                self:RegisterEvent("UI_ERROR_MESSAGE");
                bagsChecked = false;
                selling = true;
                SellItems();
            elseif ( event == "MERCHANT_CLOSED" ) then
                self:RegisterEvent("MERCHANT_SHOW");
                self:UnregisterEvent("MERCHANT_CLOSED");
                self:UnregisterEvent("UI_ERROR_MESSAGE");
                selling = false;
            elseif ( event == "UI_ERROR_MESSAGE" ) then
                messageType = ...;
                if ( messageType == 41 ) then
                    self:RegisterEvent("MERCHANT_SHOW");
                    self:UnregisterEvent("MERCHANT_CLOSED");
                    self:UnregisterEvent("UI_ERROR_MESSAGE");
                    selling = false;
                end
            end
    end);
end

local function SetRightClick()
    UrzRightClickUpdateDelay = 0;
    WorldFrame:HookScript("OnMouseUp", function(self, button)
            if ( UrzVariables[7] ) then
                if ( button == "RightButton" ) then
                    if ( UnitAffectingCombat("player") ) then
                        if ( UrzRightClickUpdateDelay < GetTime() ) then
                            UrzRightClickUpdateDelay = GetTime()+0.3;
                            MouselookStop();
                        end
                    end
                end
            end
    end);
end

local function SetURLCopy()
    for _, name in pairs({"CHAT_MSG_SAY", "CHAT_MSG_WHISPER", "CHAT_MSG_YELL", "CHAT_MSG_GUILD", "CHAT_MSG_OFFICER", "GUILD_MOTD", "CHAT_MSG_BN_WHISPER", "CHAT_MSG_BN_CONVERSATION", "CHAT_MSG_BN_INLINE_TOAST_BROADCAST", "CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER", "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER", "CHAT_MSG_INSTANCE_CHAT", "CHAT_MSG_INSTANCE_CHAT_LEADER", "CHAT_MSG_CHANNEL"}) do
        ChatFrame_AddMessageEventFilter(name, function(_, _, msg, ...)
                local newMsg, found = gsub(msg, "[^ \"£%^`¨{}%[%]\\|<>]+[^ '%-=%./,\"£%^`¨{}%[%]\\|<>%d]%.[^ '%-=%./,\"£%^`¨{}%[%]\\|<>%d][^ \"£%^`¨{}%[%]\\|<>]+", "|cff9999ff|Hurzurl~%1|h[%1]|h|r");
                if ( found > 0 ) then
                    return false, newMsg, ...;
                end
                newMsg, found = gsub(msg, "^%x+[%.:]%x+[%.:]%x+[%.:]%x+[^ \"£%^`¨{}%[%]\\|<>]*", "|cff9999ff|Hurzurl~%1|h[%1]|h|r");
                if ( found > 0 ) then
                    return false, newMsg, ...;
                end
                newMsg, found = gsub(msg, " %x+[%.:]%x+[%.:]%x+[%.:]%x+[^ \"£%^`¨{}%[%]\\|<>]*", "|cff9999ff|Hurzurl~%1|h[%1]|h|r");
                if ( found > 0 ) then
                    return false, newMsg, ...;
                end
        end);
    end
    local old = ItemRefTooltip.SetHyperlink;
    function ItemRefTooltip:SetHyperlink(data, ...)
        local isURL, link = strsplit("~", data);
        if (( isURL ) and ( isURL == "urzurl" )) then
            local activeWindow = ChatEdit_GetActiveWindow();
            if ( activeWindow ) then
                activeWindow:SetText(link);
                ChatEdit_FocusActiveWindow();
                activeWindow:HighlightText();
            else
                activeWindow = ChatEdit_GetLastActiveWindow();
                activeWindow:Show();
                activeWindow:SetText(link);
                activeWindow:SetFocus();
                activeWindow:HighlightText();
            end
        else
            old(self, data, ...);
        end
    end
end

local function HideErrorMessages(hide)
    if ( hide ) then
        UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE");
    else
        UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE");
    end
end

local function HideFloatingCombatText(hide)
    if ( hide ) then
        ConsoleExec("floatingCombatTextCombatHealing 0");
        ConsoleExec("floatingCombatTextCombatDamage 0");
    else
        ConsoleExec("floatingCombatTextCombatHealing 1");
        ConsoleExec("floatingCombatTextCombatDamage 1");
    end
end

local function UseFasterLoot(activate)
    if ( activate ) then
        if (( GetCVar("autoLootDefault") == "1" ) ~= IsModifiedClick("AUTOLOOTTOGGLE") ) then
            LootFrame:UnregisterEvent("LOOT_OPENED");
        else
            LootFrame:RegisterEvent("LOOT_OPENED");
        end
    else
        LootFrame:RegisterEvent("LOOT_OPENED");
    end
end

local function SetMisc()
    -- CastBar
    CastingBarFrame:SetFrameStrata("FULLSCREEN_DIALOG");

    -- RaidFrames
    CompactUnitFrameProfilesGeneralOptionsFrameHeightSlider:SetMinMaxValues(16, 72);

    -- TalkingHeadFrame
    hooksecurefunc("TalkingHead_LoadUI", function()
            TalkingHeadFrame:EnableMouse(false);
    end);

    -- PetJournal
    C_PetJournal.SetPetSortParameter(LE_SORT_BY_RARITY);

    -- Display money received from OpenAllMail
    local totalmoney = 0;
    OpenAllMail.ProcessNextItem = function()
        local _, _, _, _, money, CODAmount, daysLeft, itemCount, _, _, _, _, isGM = GetInboxHeaderInfo(OpenAllMail.mailIndex);
        if ( isGM or (CODAmount and CODAmount > 0) ) then
            OpenAllMail:AdvanceAndProcessNextItem();
            return;
        end
        if ( money > 0 ) then
            TakeInboxMoney(OpenAllMail.mailIndex);
            OpenAllMail.timeUntilNextRetrieval = 0.15;
            totalmoney = totalmoney + money;
        elseif ( itemCount and itemCount > 0 ) then
            TakeInboxItem(OpenAllMail.mailIndex, OpenAllMail.attachmentIndex);
            OpenAllMail.timeUntilNextRetrieval = 0.15;
        else
            OpenAllMail:AdvanceAndProcessNextItem();
        end
    end
    OpenAllMail:SetScript("OnClick", function(self, button, down)
            totalmoney = 0;
            OpenAllMail:StartOpening();
    end);
    OpenAllMail.StopOpening = function()
        if ( totalmoney > 0 ) then
            local gold = floor(abs(totalmoney / 10000));
            local silver = floor(abs(mod(totalmoney / 100, 100)));
            local copper = floor(abs(mod(totalmoney, 100)));
            local msg = format("Received %d Gold, %d Silver, %d Copper from the mail.", gold, silver, copper);
            DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 1, 0);
            totalmoney = 0;
        end
        OpenAllMail:Reset();
        OpenAllMail:Enable();
        OpenAllMail:SetText(OPEN_ALL_MAIL_BUTTON);
        OpenAllMail:UnregisterEvent("MAIL_INBOX_UPDATE");
        OpenAllMail:UnregisterEvent("MAIL_FAILED");
    end

    -- Close Cinematics without confirmation
    CinematicFrame:HookScript("OnKeyUp", function(self, key)
            if ( key == "ESCAPE" ) then
                if ( CinematicFrame:IsShown() and CinematicFrame.closeDialog and CinematicFrameCloseDialogConfirmButton ) then
                    CinematicFrameCloseDialogConfirmButton:Click();
                end
            end
    end);
    MovieFrame:HookScript("OnKeyUp", function(self, key)
            if ( key == "ESCAPE" ) then
                if ( MovieFrame:IsShown() and MovieFrame.CloseDialog and MovieFrame.CloseDialog.ConfirmButton ) then
                    MovieFrame.CloseDialog.ConfirmButton:Click();
                end
            end
    end);

    -- Map Coordinates
    UrzMapFrame = CreateFrame("Frame", "UrzMapFrame", WorldMapFrame.BorderFrame);
    UrzMapFrameText = UrzMapFrame:CreateFontString(nil, "OVERLAY", "SystemFont_Outline");
    UrzMapFrameText:SetPoint("BOTTOM", WorldMapFrame.ScrollContainer, "BOTTOM", 0, 6);
    local map, x1, y1, x2, y2;
    local delay = 0;
    local function UrzMapFrame_OnUpdate(self, elapsed)
        delay = delay - elapsed;
        if ( delay > 0 ) then
            return
        end
        delay = 0.05;

        local map = C_Map.GetBestMapForUnit("player");
        if ( map ) then
            local pos = C_Map.GetPlayerMapPosition(map, "player");
            if ( pos ) then
                x1, y1 = pos:GetXY();
            end
        end
        x2, y2 = WorldMapFrame:GetNormalizedCursorPosition();
        x1 = x1 or 0;
        x2 = x2 or 0;
        y1 = y1 or 0;
        y2 = y2 or 0;
        UrzMapFrameText:SetText(format("Player: %.1fx %.1fy   Cursor: %.1fx %.1fy", x1*100, y1*100, x2*100, y2*100));
    end
    UrzMapFrame:SetScript("OnUpdate", UrzMapFrame_OnUpdate);
end

local function SetOptionsframe()
    CreateFrame("Frame", "UrzVariablesInterface");
    UrzVariablesInterface.name = "UrzUI";
    InterfaceOptions_AddCategory(UrzVariablesInterface);
    SlashCmdList["UrzSlash"] = function(UrzVariables)
        InterfaceOptionsFrame:Show();
        InterfaceOptionsFrame_OpenToCategory("UrzUI");
    end;
    SLASH_UrzSlash1 = "/urz";
    UrzSettings = {
        [2] = {x = 24, y = 50+35*1, Text = "Hide error messages"},
        [11] = {x = 24, y = 50+35*2, Text = "Hide floating combat text"},
        [3] = {x = 24, y = 50+35*3, Text = "Auto repair"},
        [4] = {x = 174, y = 50+35*3, Text = "Auto guild repair"},
        [5] = {x = 24, y = 50+35*4, Text = "Auto sell poor quality items"},
        [8] = {x = 24, y = 50+35*5, Text = "Auto turn in and accept quests"},
        [9] = {x = 24, y = 60+35*6, Text = "Faster auto loot"},
        [7] = {x = 24, y = 70+35*7, Text = "Require right-double-click to loot, attack and interact with objects in combat"},
        [1] = {x = 24, y = 130+35*8, Text = "Nameplates"},
        [10] = {x = 174, y = 130+35*8, Text = "Minimap"},
        [14] = {x = 324, y = 130+35*8, Text = "Chat"},
        [15] = {x = 24, y = 130+35*9, Text = "Unit frames"},
        [13] = {x = 174, y = 130+35*9, Text = "Main menu & Action bar"},
        [12] = {x = 24, y = 130+35*10, Text = "Hide bags and micro buttons"},
    };
    local box = {};
    for i = 1, #UrzSettings do
        if ( UrzSettings[i] ) then
            box[i] = CreateFrame("CheckButton", "box"..i, UrzVariablesInterface, "InterfaceOptionsCheckButtonTemplate");
            Move(box[i], "TOPLEFT", UrzVariablesInterface, "TOPLEFT", UrzSettings[i]["x"], -UrzSettings[i]["y"]);
            box[i]:SetChecked(UrzVariables[i]);
            _G[box[i]:GetName().."Text"]:SetText(UrzSettings[i]["Text"]);
            box[i]:SetScript("OnClick", function(self, button, down)
                    UrzVariables[i] = self:GetChecked();
            end);
            UrzVariablesInterface:SetScript("OnShow", function(self)
                    for i = 1, #UrzSettings do
                        if ( box[i] ) then
                            box[i]:SetChecked(UrzVariables[i]);
                        end
                    end
            end);
        end
    end
    box[2]:HookScript("OnClick", function(self, button, down)
            HideErrorMessages(UrzVariables[2]);
    end);
    box[11]:HookScript("OnClick", function(self, button, down)
            HideFloatingCombatText(UrzVariables[11]);
    end);
    box[9]:HookScript("OnClick", function(self, button, down)
            UseFasterLoot(UrzVariables[9]);
    end);
    local text1 = UrzVariablesInterface:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    local text2 = UrzVariablesInterface:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
    local text3 = UrzVariablesInterface:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    local text4 = UrzVariablesInterface:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    local text5 = UrzVariablesInterface:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
    local text6 = UrzVariablesInterface:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
    local text7 = UrzVariablesInterface:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
    local text8 = UrzVariablesInterface:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
    text1:SetText("UrzUI");
    text2:SetText("Dedicated to my wife Madelene.");
    text3:SetText("Optional functions");
    text4:SetText("Interface tweaks");
    text5:SetText("Requires a reload for changes to take effect.");
    text6:SetText("This means that you can no longer accidentally target or attack a mob when you move the camera.");
    text7:SetText("Hold down shift to disable temporarily.");
    text8:SetText("This means that the loot window will not be shown during auto loot.");
    text6:SetJustifyH("LEFT");
    text1:SetPoint("TOPLEFT", 16, -16);
    text2:SetPoint("TOPLEFT", text1, "BOTTOMLEFT", 0, -8);
    text3:SetPoint("BOTTOMLEFT", box[2], "TOPLEFT", 0, 8);
    text4:SetPoint("BOTTOMLEFT", text5, "TOPLEFT", 0, 8);
    text5:SetPoint("BOTTOMLEFT", box[1], "TOPLEFT", 0, 8);
    text6:SetPoint("TOPLEFT", box[7], "BOTTOMLEFT", 40, 2);
    text7:SetPoint("TOPLEFT", box[8], "BOTTOMLEFT", 40, 2);
    text8:SetPoint("TOPLEFT", box[9], "BOTTOMLEFT", 40, 2);
    local b = CreateFrame("Button", nil, UrzVariablesInterface, "UIPanelButtonTemplate");
    b:SetSize(100, 22);
    b:SetText("Reload UI");
    b:SetPoint("BOTTOMRIGHT", -16, 16);
    b:SetScript("OnClick", function(self, button, down)
            ReloadUI();
    end)
end

local function EventHandler(self, event, ...)
    if ( event == "MERCHANT_SHOW" ) then
        if ( CanMerchantRepair() ) then
            local cost = GetRepairAllCost();
            if ( cost > 0 ) then
                local done = false;
                if ( IsInGuild() ) and ( CanGuildBankRepair() ) then
                    if ( cost <= GetGuildBankWithdrawMoney() ) then
                        if ( UrzVariables[4] ) then
                            done = true;
                            RepairAllItems(1);
                        end
                    end
                end
                if ( UrzVariables[3] and not done ) then
                    RepairAllItems();
                end
            end
        end
    elseif ( event == "MODIFIER_STATE_CHANGED" ) then
        if ( UrzVariables[9] ) then
            UseFasterLoot(true);
        end
    elseif ( event == "LOOT_OPENED" ) then
        if ( UrzVariables[9] ) then
            auto = ...;
            if ( auto == 1 ) then
                for i = 0, GetNumLootItems(), 1 do
                    LootSlot(i);
                end
            end
        end
    elseif (( event == "AUCTION_HOUSE_SHOW" ) or ( event == "BANKFRAME_OPENED" ) or ( event == "GUILDBANKFRAME_OPENED" ) or ( event == "VOID_STORAGE_OPEN" ) or ( event == "SCRAPPING_MACHINE_SHOW" )) then
        CloseAllBags();
        OpenAllBags();
        if ( event == "BANKFRAME_OPENED" ) then
            local numSlots = GetNumBankSlots();
            for i = 0, numSlots do
                OpenBag(NUM_BAG_SLOTS + 1 + i);
            end
        end
    elseif (( UrzVariables[8] ) and ( not IsShiftKeyDown() )) then
        if ( event == "QUEST_DETAIL" ) then
            if ( not QuestGetAutoAccept() ) then
                AcceptQuest();
            else
                CloseQuest();
            end
        end
        if ( event == "QUEST_ACCEPT_CONFIRM" ) then
            ConfirmAcceptQuest();
            StaticPopup_Hide("QUEST_ACCEPT_CONFIRM");
        end
        if ( event == "QUEST_PROGRESS" ) then
            if ( IsQuestCompletable() ) then
                CompleteQuest();
            end
        end
        if ( event == "QUEST_COMPLETE" ) then
            if ( GetNumQuestChoices() <= 1 ) then
                GetQuestReward(GetNumQuestChoices());
            end
        end
    end
end

local function LoadAddon(self, event, ...)
    EventWatcher:UnregisterAllEvents();
    SetMainMenu();
    SetChatframes();
    SetUnitframes();
    SetMinimap();
    HideBags();
    SetAutoSell();
    SetRightClick();
    SetURLCopy();
    SetMisc();
    SetOptionsframe();
    HideErrorMessages(UrzVariables[2]);
    HideFloatingCombatText(UrzVariables[11]);
    UseFasterLoot(UrzVariables[9]);
    EventWatcher:SetScript("OnEvent", EventHandler);
    EventWatcher:RegisterEvent("MERCHANT_SHOW");
    EventWatcher:RegisterEvent("LOOT_OPENED");
    EventWatcher:RegisterEvent("MODIFIER_STATE_CHANGED");
    EventWatcher:RegisterEvent("QUEST_DETAIL");
    EventWatcher:RegisterEvent("QUEST_ACCEPT_CONFIRM");
    EventWatcher:RegisterEvent("QUEST_PROGRESS");
    EventWatcher:RegisterEvent("QUEST_COMPLETE");
    EventWatcher:RegisterEvent("AUCTION_HOUSE_SHOW");
    EventWatcher:RegisterEvent("BANKFRAME_OPENED");
    EventWatcher:RegisterEvent("GUILDBANKFRAME_OPENED");
    EventWatcher:RegisterEvent("VOID_STORAGE_OPEN");
    EventWatcher:RegisterEvent("SCRAPPING_MACHINE_SHOW");
    collectgarbage();
end

local function LoginEvent(self, event, ...)
    EventWatcher:UnregisterAllEvents();
    if (( not UrzVariables ) or (( UrzVariables ) and ( type(UrzVariables) ~= "table" )) or ( UrzVariables[0] ~= 1.40 )) then
        print('UrzUI has reseted all options due to an update. Check your settings by typing: "/urz".');
        UrzVariables = {[0] = 1.40, [1] = 1, [3] = 1, [5] = 1, [8] = 1, [10] = 1, [13] = 1, [14] = 1, [15] = 1,};
    end
    SetNameplates(); -- Can be loaded in combat. Needs to be loaded before the first nameplate is loaded.
    if ( UnitAffectingCombat("player") ) then
        EventWatcher:SetScript("OnEvent", LoadAddon);
        EventWatcher:RegisterEvent("PLAYER_REGEN_ENABLED");
    else
        LoadAddon();
    end
end
EventWatcher:SetScript("OnEvent", LoginEvent);
EventWatcher:RegisterEvent("PLAYER_ENTERING_WORLD");
