// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import "./menu";

// エラーメッセージを保持する配列
let validationErrors = [];

function clearValidationErrors() {
  validationErrors = [];
}

// エラーメッセージを整形する関数
function formatErrorMessages(errors) {
  // フィールド名を抽出
  const fieldNames = errors
    .filter(error => error.endsWith('を入力してください。'))
    .map(error => error.replace('を入力してください。', ''));

  // その他のエラーメッセージを抽出
  const otherErrors = errors.filter(error => !error.endsWith('を入力してください。'));

  // メッセージを組み立て
  let message = '';

  if (fieldNames.length > 0) {
    message = `${fieldNames.join('・')}を入力してください。`;
  }

  if (otherErrors.length > 0) {
    if (message) message += '<br>';
    message += otherErrors.join('<br>');
  }

  return message;
}

document.addEventListener('invalid', e => {
  e.preventDefault();

  // フィールド名を取得
  const fieldName = e.target.getAttribute('name');
  const label = e.target.labels?.[0]?.textContent || fieldName;
  let errorMessage = e.target.validationMessage;

  // デフォルトのメッセージをカスタマイズ（toastになると「このフィールド」では分からないため）
  if (errorMessage === 'このフィールドを入力してください。') {
    errorMessage = `${label}を入力してください。`;
  } else if (errorMessage === 'Please fill out this field.') {
    errorMessage = `Please enter ${label}.`;
  }

  if (!validationErrors.includes(errorMessage)) {
    validationErrors.push(errorMessage);
  }

  // 既存のタイマーをクリア
  if (window.validationErrorTimer) {
    clearTimeout(window.validationErrorTimer);
  }

  // 新しいタイマーを設定（100ms後にエラーメッセージを表示）
  window.validationErrorTimer = setTimeout(() => {
    // ToastControllerを使用してエラーメッセージを表示
    const toastController = document.querySelector('[data-controller="toast"]');
    if (toastController) {
      const controller = Stimulus.getControllerForElementAndIdentifier(toastController, 'toast');
      if (controller) {
        controller.showError(formatErrorMessages(validationErrors));
      }
    }
    // エラーメッセージをクリア
    clearValidationErrors();
  }, 100);
}, true);

// フォームのsubmitイベントでエラーメッセージをクリア
document.addEventListener('submit', () => {
  clearValidationErrors();
  if (window.validationErrorTimer) {
    clearTimeout(window.validationErrorTimer);
  }
});

// カレンダーセルクリックで日付リンクに遷移
document.addEventListener('click', function(e) {
  // calendar-cellのtdかどうか判定
  const td = e.target.closest('td.calendar-cell');
  if (!td) return;

  // aタグやbuttonがクリックされた場合は何もしない
  if (e.target.closest('a') || e.target.closest('button')) return;

  // 優先: a.report-date, 次: a.new-report-date
  const link = td.querySelector('a.report-date, a.new-report-date');
  if (link && link.href) {
    window.location.href = link.href;
  }
});
