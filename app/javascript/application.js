// Entry point for the build script in your package.json
import * as bootstrap from "bootstrap"
import React from "react";
import ReactDOM from "react-dom/client";

document.addEventListener('DOMContentLoaded', () => {
  // タグ選択のチェックボックスグループ
  const tagCheckboxGroup = document.querySelector('.tag-checkbox-group');

  if (tagCheckboxGroup) {
    const checkboxes = tagCheckboxGroup.querySelectorAll('.tag-checkbox');
    const maxSelection = parseInt(tagCheckboxGroup.dataset.maxSelection, 10); // data-max-selectionから取得

    const updateCheckboxState = () => {
      const selectedCheckboxes = Array.from(checkboxes).filter(cb => cb.checked);

      if (selectedCheckboxes.length >= maxSelection) {
        // 最大選択数に達したら、選択されていない他のチェックボックスを無効化
        Array.from(checkboxes).forEach(cb => {
          if (!cb.checked) {
            cb.disabled = true;
          }
        });
      } else {
        // 最大選択数に達していなければ、すべてのチェックボックスを有効化
        Array.from(checkboxes).forEach(cb => {
          cb.disabled = false;
        });
      }
    };

    // 初期ロード時に状態を更新
    updateCheckboxState();

    // 各チェックボックスの変更イベントを監視
    checkboxes.forEach(checkbox => {
      checkbox.addEventListener('change', updateCheckboxState);
    });
  }
  // --- 投稿削除機能のJavaScript (ここから追加) ---
  document.querySelectorAll('.delete-post-link').forEach(link => {
    link.addEventListener('click', (event) => {
      event.preventDefault(); // デフォルトのリンク動作をキャンセル

      const confirmMessage = event.target.dataset.confirm || 'Are you sure?'; // data-confirm属性からメッセージを取得

      if (confirm(confirmMessage)) { // 確認ダイアログを表示
        const form = document.createElement('form');
        form.method = 'POST'; // DELETEリクエストはPOSTで偽装し、_methodパラメータで指定
        form.action = event.target.href; // リンクのhref属性をactionに設定

        // _method フィールドを追加して、RailsにDELETEリクエストとして処理させる
        const methodField = document.createElement('input');
        methodField.type = 'hidden';
        methodField.name = '_method';
        methodField.value = 'delete';
        form.appendChild(methodField);

        // CSRFトークンを追加
        const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;
        const csrfParam = document.querySelector('meta[name="csrf-param"]')?.content;

        if (csrfToken && csrfParam) {
          const csrfField = document.createElement('input');
          csrfField.type = 'hidden';
          csrfField.name = csrfParam;
          csrfField.value = csrfToken;
          form.appendChild(csrfField);
        }

        document.body.appendChild(form); // フォームをDOMに追加
        form.submit(); // フォームを送信
      }
    });
  });
  document.querySelectorAll('.delete-comment-link').forEach(link => {
    link.addEventListener('click', (event) => {
      event.preventDefault(); // デフォルトのリンク動作をキャンセル

      const confirmMessage = event.target.dataset.confirm || 'Are you sure?';

      if (confirm(confirmMessage)) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = event.target.href;

        const methodField = document.createElement('input');
        methodField.type = 'hidden';
        methodField.name = '_method';
        methodField.value = 'delete';
        form.appendChild(methodField);

        const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;
        const csrfParam = document.querySelector('meta[name="csrf-param"]')?.content;

        if (csrfToken && csrfParam) {
          const csrfField = document.createElement('input');
          csrfField.type = 'hidden';
          csrfField.name = csrfParam;
          csrfField.value = csrfToken;
          form.appendChild(csrfField);
        }

        document.body.appendChild(form);
        form.submit();
      }
    });
  });
});