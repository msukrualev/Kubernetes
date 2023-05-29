https://raw.githubusercontent.com/linuxacademy/content-cka-resources/master/metrics-server-components.yaml

# kubectl apply -f  " ilgili url "   ile uzaktan olarak, locale pluginleri indirmeden sistemimizde calistirabiliyoruz.


kubectl get --raw /apis/metrics.k8s.io/   #komutu ile yukarda indirdigimiz metrics icerigini calistiririz.

#poweshell'de bash'teki  | grep "xyz"  komutunun karsiligi: | Select-String "xyz?"

# kubectl api-resources | Select-String "pod"

#alttaki komutlar windowsta görev yöneticisi gibi linuxteki formatinda kullanilan kaynak degerlerini gösterir.
kubectl top po
kubectl top pod --sort-by memory # --sort-by parametresi ismi yazilan kaynaklari siralar
kubectl top pod --sort-by cpu

# etiketler ile filtreleyebiliriz
kubectl top pod --selector app=name