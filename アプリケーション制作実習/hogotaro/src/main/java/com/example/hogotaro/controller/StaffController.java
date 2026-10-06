package com.example.hogotaro.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.hogotaro.entity.Gender;
import com.example.hogotaro.entity.Staff;
import com.example.hogotaro.form.StaffForm;
import com.example.hogotaro.form.StaffSearchForm;
import com.example.hogotaro.security.LoginUser;
import com.example.hogotaro.service.StaffService;

import lombok.RequiredArgsConstructor;

@Controller // アプリ起動時にSpringが1個だけnewして管理する
@RequiredArgsConstructor // finalフィールドを受け取るコンストラクタをLombokが生成する
public class StaffController {

    private final StaffService staffService;
    private final LoginUser loginUser;

    // スタッフ一覧・検索（F-27）
    @GetMapping("/staff")
    public String list(
            @ModelAttribute("searchForm") StaffSearchForm form,
            Model model) {

        model.addAttribute(
                "staffList",
                staffService.search(loginUser.getOrganizationId(), form));

        return "staff/list";
    }

    // スタッフ詳細（F-28）
    @GetMapping("/staff/{id}")
    public String detail(
            @PathVariable Integer id,
            Model model) {

        Integer organizationId = loginUser.getOrganizationId();
        Staff staff = staffService.find(id, organizationId);

        model.addAttribute("staff", staff);
        model.addAttribute(
                "eventList",
                staffService.findEventList(id, organizationId));

        return "staff/detail";
    }

    // スタッフ新規登録画面（F-29）
    @GetMapping("/staff/new")
    public String newForm(Model model) {
        model.addAttribute("staffForm", new StaffForm());
        model.addAttribute("mode", "new");
        model.addAttribute("userTypeList", staffService.findUserTypes());
        model.addAttribute("genderList", Gender.values());

        return "staff/form";
    }

    // スタッフ新規登録（F-30）
    @PostMapping("/staff/new")
    public String create(
            @Validated @ModelAttribute("staffForm") StaffForm staffForm,
            BindingResult result,
            Model model,
            RedirectAttributes redirectAttributes) {

        // Formのアノテーションによる入力チェック
        if (result.hasErrors()) {
            model.addAttribute("mode", "new");
            model.addAttribute("userTypeList", staffService.findUserTypes());
            model.addAttribute("genderList", Gender.values());
            return "staff/form";
        }

        // アノテーションだけでは確認できない項目をServiceでチェック
        Integer id = staffService.create(
                staffForm,
                result,
                loginUser.getOrganizationId());

        // ログインID重複、ユーザー種別不正、パスワード未入力など
        if (result.hasErrors()) {
            model.addAttribute("mode", "new");
            model.addAttribute("userTypeList", staffService.findUserTypes());
            model.addAttribute("genderList", Gender.values());
            return "staff/form";
        }

        redirectAttributes.addFlashAttribute(
                "message",
                "スタッフ新規登録が完了しました");

        return "redirect:/staff/" + id;
    }

    // スタッフ編集画面（F-31）
    @GetMapping("/staff/{id}/edit")
    public String editForm(
            @PathVariable Integer id,
            Model model) {

        Integer organizationId = loginUser.getOrganizationId();
        Staff staff = staffService.find(id, organizationId);

        model.addAttribute("staffForm", staffService.toForm(staff));
        model.addAttribute("mode", "edit");
        model.addAttribute("staff", staff);
        model.addAttribute("userTypeList", staffService.findUserTypes());
        model.addAttribute("genderList", Gender.values());

        return "staff/form";
    }

    // スタッフ編集（F-32）
    @PostMapping("/staff/{id}/edit")
    public String update(
            @PathVariable Integer id,
            @Validated @ModelAttribute("staffForm") StaffForm staffForm,
            BindingResult result,
            Model model,
            RedirectAttributes redirectAttributes) {

        Integer organizationId = loginUser.getOrganizationId();

        // Formのアノテーションによる入力チェック
        if (result.hasErrors()) {
            model.addAttribute("staff", staffService.find(id, organizationId));
            model.addAttribute("mode", "edit");
            model.addAttribute("userTypeList", staffService.findUserTypes());
            model.addAttribute("genderList", Gender.values());
            return "staff/form";
        }

        // ユーザー種別の存在確認、自分自身のユーザー種別変更禁止など
        staffService.update(
                id,
                staffForm,
                result,
                organizationId,
                loginUser.getStaffId());

        // Service側でエラーが追加された場合は保存せず再表示
        if (result.hasErrors()) {
            model.addAttribute("staff", staffService.find(id, organizationId));
            model.addAttribute("mode", "edit");
            model.addAttribute("userTypeList", staffService.findUserTypes());
            model.addAttribute("genderList", Gender.values());
            return "staff/form";
        }

        redirectAttributes.addFlashAttribute(
                "message",
                "スタッフを編集しました");

        return "redirect:/staff/" + id;
    }

    // スタッフ削除（F-33）
    @PostMapping("/staff/{id}/delete")
    public String delete(
            @PathVariable Integer id,
            RedirectAttributes redirectAttributes) {

        boolean deleted = staffService.delete(
                id,
                loginUser.getOrganizationId(),
                loginUser.getStaffId());

        if (!deleted) {
            redirectAttributes.addFlashAttribute(
                    "message",
                    "自分自身は削除できません");
            return "redirect:/staff/" + id;
        }

        redirectAttributes.addFlashAttribute(
                "message",
                "スタッフを削除しました");

        return "redirect:/staff";
    }
}
