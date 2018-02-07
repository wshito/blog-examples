;;;
;;; See http://diary.wshito.com/comp/lisp/clack/lack-middleware-session/
;;; for explanation.
;;;

(ql:quickload 'clack)
(ql:quickload 'lack)

(defun starts-with (str prefix)
  (when (>= (length str) (length prefix))
    (string= (subseq str 0 (length prefix)) prefix)))

;;; Middleware to proctect the secure area
;;; :uidが設定されていない場合，protected-pathにアクセスすると
;;; redirect関数を呼び出してログインページへリダイレクトする．
(defun secure-mw (redirect protected-path)
  (lambda (app)
    (lambda (env)
      ;; preprocessing
      (let* ((url (getf env :path-info))
             (session (getf env :lack.session))
             (uid (gethash :uid session)))
        (if (and (null uid)
                 (dolist (prefix protected-path)
                        (when (starts-with url prefix) (return t))))
            (progn
              ;;当初のアクセス先をセッション変数に保存
              (setf (gethash :prev-url session) url)
              (funcall redirect))
            (funcall app env))))))

;;; ログインページへリダイレクトするレスポンスを返す．
(defun redirect-to-login-page ()
  '(303 (:location "/login") ("")))

(defun get-uid (env)
  (gethash :uid (getf env :lack.session)))

(defun page-header ()
  '("<html><h1>Lack Session Middleware Test</h1>
   <h2>--- Login Logout Example ---</h2>
   <p>Access any directories.  Any directories under '<b>/private</b>' needs to be logged in to access.</p>
   <hr />
   "))

(defun status (uid)
  (if uid
      `("<p>You are logged in as " ,uid ".  (<a href='/logout'>logout</a>)</p>")
      `("<p><a href='/login'>Login</a></p>")))

(defun page-footer ()
  '("</html>"))

(defun login-form ()
  ;; /auth にuidとpasswdをPOST
  '("<p>Use '<b>wshito</b>' for username, '<b>mypass</b>' for password.</p>
     <form action='/auth' method='post'>
     <p>Username:
        <input type='text' name='uname' maxlength='32' autocomplete='OFF' /></p>
     <p>Password:
        <input type='password' name='passwd' maxlength='32' autocomplete='OFF' /></p>
     <p><input type='submit' value='Login' /></p>
   </form>"))

;;; ログインページ
(defparameter *login*
  (lambda (env)
    (let ((uid (get-uid env)))
      `(200 (:content-type "text/html")
            ,(append (page-header)
                     (if uid                       
                         (list "<p>You are already logged in as " uid ".</p>")
                         (login-form))
                     (page-footer))))))

;;; ログアウトページ
(defparameter *logout*
  (lambda (env)
    (setf (getf (getf env :lack.session.options) :expire) t)
    `(200 (:content-type "text/html")
          ,(append (page-header)
                   (list "<p>You have logged out.</p>")
                   (page-footer)))))

;;; 認証関数    
(defun authenticate (name password)
  (and (string= name "wshito")
       (string= password "mypass")))

;;; :body-parameters内にはPOSTで送られたパラメータが，ドット対
;;; のリストとして保持されている．この場合だと，
;;; (("uname" . "wshito") ("passwd" . "mypass"))
(defparameter *auth*
  (lambda (env)
    (let* ((params (getf env :body-parameters))
           (name (cdr (assoc "uname" params :test #'string=)))
           (pass (cdr (assoc "passwd" params :test #'string=))))
      (if (and (= (length params) 2)
               (authenticate name pass))
          (let* ((session (getf env :lack.session))
                 (url (gethash :prev-url session "/")))
            (setf (gethash :uid session "/") name)
            `(303 (:location ,url) ("")))
          (redirect-to-login-page)))))

;;; ログインが必要なprivateエリア
(defparameter *private*
  (lambda (env)
    (let* ((session (getf env :lack.session))
           (uid (gethash :uid session nil))
           ;; /privateにmountしているのでpathには/privateが含まれない
           (path (concatenate 'string "/private" (getf env :path-info))))
      `(200 (:content-type "text/html")
            ,(append (page-header)
                     (status uid)
                     (list "<p>Private Area: path = " path "</p>")
                     (page-footer))))))
              
;;;
;;; Main App
;;;
(defparameter *sample-app*
  (lambda (env)
    (let* ((session (getf env :lack.session))
           (uid (gethash :uid session))
           (path (getf env :path-info)))
      (when (null uid) (setf (gethash :prev-url session) path))
      `(200 (:content-type "text/html")
            ,(append (page-header)
                     (status uid)
                     (list "<p>path = " path "</p>")
                     (page-footer))))))

;;;
;;; Creates Lack Application
;;; builderチェーンの最後だけが1重lambdaで，それ以外は2重lambda．
;;; builderされ*app*に渡される内容は外側のlambda式がfuncallで呼びだされた
;;; 後の結果．外側のlambdaはbuilder時に実行される．
(defparameter *app*
  (lack:builder
   :session
   (secure-mw #'redirect-to-login-page '("/private"))
   (:mount "/login" *login*)
   (:mount "/auth" *auth*)
   (:mount "/logout" *logout*)
   (:mount "/private" *private*)
   *sample-app*))

;;;
;;; Starts the Web server
;;;
(defparameter *handler*
  (clack:clackup *app*))

;;;
;;; Stops the Web server
;;;
;; (clack:stop *handler*)
